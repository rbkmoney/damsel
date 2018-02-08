/**
 * Определения предметной области.
 */

include "base.thrift"
include "msgpack.thrift"
include "json.thrift"

namespace java com.rbkmoney.damsel.domain
namespace erlang domain

typedef i64        DataRevision
typedef i32        ObjectID
typedef json.Value Metadata

/* Common */

/** Контактная информация. **/
struct ContactInfo {
    1: optional string phone_number
    2: optional string email
}

union OperationFailure {
    1: OperationTimeout operation_timeout
    2: ExternalFailure  external_failure
}

struct OperationTimeout {}

struct ExternalFailure {
    /** Уникальный признак ошибки, пригодный для обработки машиной */
    1: required string code
    /** Описание ошибки, пригодное для восприятия человеком */
    2: optional string description
}

/** Сумма в минимальных денежных единицах. */
typedef i64 Amount

/** Номер счёта. */
typedef i64 AccountID

/** Денежные средства, состоящие из суммы и валюты. */
struct Cash {
    1: required Amount amount
    2: required CurrencyRef currency
}

/* Contractor transactions */

struct TransactionInfo {
    1: required string id
    2: optional base.Timestamp timestamp
    3: required base.StringMap extra
}

/* Invoices */

typedef base.ID InvoiceID
typedef base.ID InvoicePaymentID
typedef base.ID InvoicePaymentRefundID
typedef base.ID InvoicePaymentAdjustmentID
typedef base.Content InvoiceContext
typedef base.Content InvoicePaymentContext
typedef string PaymentSessionID
typedef string Fingerprint
typedef string IPAddress

struct Invoice {
    1 : required InvoiceID id
    2 : required PartyID owner_id
    13: optional PartyRevision party_revision
    3 : required ShopID shop_id
    4 : required base.Timestamp created_at
    6 : required InvoiceStatus status
    7 : required InvoiceDetails details
    8 : required base.Timestamp due
    10: required Cash cost
    11: optional InvoiceContext context
    12: optional InvoiceTemplateID template_id
}

struct InvoiceDetails {
    1: required string product
    2: optional string description
    3: optional InvoiceCart cart
}

struct InvoiceCart {
    1: required list<InvoiceLine> lines
}

struct InvoiceLine {
    1: required string product
    2: required i32 quantity
    3: required Cash price
    /* Taxes and other stuff goes here */
    4: required map<string, msgpack.Value> metadata
}

struct InvoiceUnpaid    {}
struct InvoicePaid      {}
struct InvoiceCancelled { 1: required string details }
struct InvoiceFulfilled { 1: required string details }

union InvoiceStatus {
    1: InvoiceUnpaid unpaid
    2: InvoicePaid paid
    3: InvoiceCancelled cancelled
    4: InvoiceFulfilled fulfilled
}

struct InvoicePayment {
    1:  required InvoicePaymentID id
    2:  required base.Timestamp created_at
    10: required DataRevision domain_revision
    15: optional PartyRevision party_revision
    3:  required InvoicePaymentStatus status
    14: required Payer payer
    8:  required Cash cost
    13: required InvoicePaymentFlow flow
    6:  optional InvoicePaymentContext context
}

struct InvoicePaymentPending   {}
struct InvoicePaymentProcessed {}
struct InvoicePaymentCaptured  { 1: optional string reason }
struct InvoicePaymentCancelled { 1: optional string reason }
struct InvoicePaymentRefunded  {}
struct InvoicePaymentFailed    { 1: required OperationFailure failure }

/**
 * Шаблон инвойса.
 * Согласно https://github.com/rbkmoney/coredocs/blob/0a5ae1a79f977be3134c3b22028631da5225d407/docs/domain/entities/invoice.md#шаблон-инвойса
 */

typedef base.ID InvoiceTemplateID

struct InvoiceTemplate {
    1:  required InvoiceTemplateID id
    2:  required PartyID owner_id
    3:  required ShopID shop_id
    5:  required LifetimeInterval invoice_lifetime
    9:  required string product # for backward compatibility
    10: optional string description
    8:  required InvoiceTemplateDetails details
    7:  optional InvoiceContext context
}

union InvoiceTemplateDetails {
    1: InvoiceCart cart
    2: InvoiceTemplateProduct product
}

struct InvoiceTemplateProduct {
    1: required string product
    2: required InvoiceTemplateProductPrice price
    3: required map<string, msgpack.Value> metadata
}

union InvoiceTemplateProductPrice {
    1: Cash fixed
    2: CashRange range
    3: InvoiceTemplateCostUnlimited unlim
}

struct InvoiceTemplateCostUnlimited {}

/**
 * Статус платежа.
 */
union InvoicePaymentStatus {
    1: InvoicePaymentPending pending
    4: InvoicePaymentProcessed processed
    2: InvoicePaymentCaptured captured
    5: InvoicePaymentCancelled cancelled
    6: InvoicePaymentRefunded refunded
    3: InvoicePaymentFailed failed
}

/**
 * Целевое значение статуса платежа.
 */
union TargetInvoicePaymentStatus {

    /**
     * Платёж обработан.
     *
     * При достижении платежом этого статуса процессинг должен обладать:
     *  - фактом того, что провайдер _по крайней мере_ авторизовал списание денежных средств в
     *    пользу системы;
     *  - данными транзакции провайдера.
     */
    1: InvoicePaymentProcessed processed

    /**
     * Платёж подтверждён.
     *
     * При достижении платежом этого статуса процессинг должен быть уверен в том, что провайдер
     * _по крайней мере_ подтвердил финансовые обязательства перед системой.
     */
    2: InvoicePaymentCaptured captured

    /**
     * Платёж отменён.
     *
     * При достижении платежом этого статуса процессинг должен быть уверен в том, что провайдер
     * аннулировал неподтверждённое списание денежных средств.
     *
     * В случае, если в рамках сессии проведения платежа провайдер авторизовал, но _ещё не
     * подтвердил_ списание средств, эта цель является обратной цели `processed`. В ином случае
     * эта цель недостижима, и взаимодействие в рамках сессии должно завершится с ошибкой.
     */
    3: InvoicePaymentCancelled cancelled

    /**
     * Платёж возвращён.
     *
     * При достижении платежом этого статуса процессинг должен быть уверен в том, что провайдер
     * возвратил денежные средства плательщику, потраченные им в ходе подтверждённого списания.
     *
     * Если эта цель недостижима, взаимодействие в рамках сессии должно завершится с ошибкой.
     */
    4: InvoicePaymentRefunded refunded

}

union Payer {
    1: PaymentResourcePayer payment_resource
    2: CustomerPayer        customer
}

struct PaymentResourcePayer {
    1: required DisposablePaymentResource resource
    2: required ContactInfo               contact_info
}

struct CustomerPayer {
    1: required CustomerID             customer_id
    2: required CustomerBindingID      customer_binding_id
    3: required RecurrentPaymentToolID rec_payment_tool_id
    4: required PaymentTool            payment_tool
    5: required ContactInfo            contact_info
}

struct ClientInfo {
    1: optional IPAddress ip_address
    2: optional Fingerprint fingerprint
}

struct PaymentRoute {
    1: required ProviderRef provider
    2: required TerminalRef terminal
}

/* Adjustments */

struct InvoicePaymentAdjustment {
    1: required InvoicePaymentAdjustmentID id
    2: required InvoicePaymentAdjustmentStatus status
    3: required base.Timestamp created_at
    4: required DataRevision domain_revision
    5: required string reason
    6: required FinalCashFlow new_cash_flow
    7: required FinalCashFlow old_cash_flow_inverse
}

struct InvoicePaymentAdjustmentPending   {}
struct InvoicePaymentAdjustmentCaptured  { 1: required base.Timestamp at }
struct InvoicePaymentAdjustmentCancelled { 1: required base.Timestamp at }

union InvoicePaymentAdjustmentStatus {
    1: InvoicePaymentAdjustmentPending pending
    2: InvoicePaymentAdjustmentCaptured captured
    3: InvoicePaymentAdjustmentCancelled cancelled
}

/**
 * Процесс выполнения платежа.
 */
union InvoicePaymentFlow {
    1: InvoicePaymentFlowInstant instant
    2: InvoicePaymentFlowHold hold
}

struct InvoicePaymentFlowInstant   {}

struct InvoicePaymentFlowHold {
    1: required OnHoldExpiration on_hold_expiration
    2: required base.Timestamp held_until
}

enum OnHoldExpiration {
    cancel
    capture
}

/* Refunds */

struct InvoicePaymentRefund {
    1: required InvoicePaymentRefundID id
    2: required InvoicePaymentRefundStatus status
    3: required base.Timestamp created_at
    4: required DataRevision domain_revision
    5: optional string reason
}

union InvoicePaymentRefundStatus {
    1: InvoicePaymentRefundPending pending
    2: InvoicePaymentRefundSucceeded succeeded
    3: InvoicePaymentRefundFailed failed
}

struct InvoicePaymentRefundPending {}
struct InvoicePaymentRefundSucceeded {}

struct InvoicePaymentRefundFailed {
    1: required OperationFailure failure
}

/* Blocking and suspension */

union Blocking {
    1: Unblocked unblocked
    2: Blocked   blocked
}

struct Unblocked {
    1: required string reason
    2: required base.Timestamp since
}

struct Blocked {
    1: required string reason
    2: required base.Timestamp since
}

union Suspension {
    1: Active    active
    2: Suspended suspended
}

struct Active {
    1: required base.Timestamp since
}

struct Suspended {
    1: required base.Timestamp since
}

/* Parties */

typedef base.ID PartyID
typedef i64 PartyRevision

typedef string PartyMetaNamespace
typedef msgpack.Value PartyMetaData
typedef map<PartyMetaNamespace, PartyMetaData> PartyMeta

/** Участник. */
struct Party {
    1: required PartyID id
    7: required PartyContactInfo contact_info
    8: required base.Timestamp created_at
    2: required Blocking blocking
    3: required Suspension suspension
    4: required map<ContractID, Contract> contracts
    5: required map<ShopID, Shop> shops
    6: required PartyRevision revision
}

struct PartyContactInfo {
    1: required string email
}

/* Shops */

typedef base.ID ShopID

/** Магазин мерчанта. */
struct Shop {
    1: required ShopID id
   11: required base.Timestamp created_at
    2: required Blocking blocking
    3: required Suspension suspension
    4: required ShopDetails details
   10: required ShopLocation location
    5: required CategoryRef category
    6: optional ShopAccount account
    7: required ContractID contract_id
    8: optional PayoutToolID payout_tool_id
   12: optional ScheduleRef payout_schedule
}

struct ShopAccount {
    1: required CurrencyRef currency
    2: required AccountID settlement
    3: required AccountID guarantee
    /* Аккаунт на который выводятся деньги из системы */
    4: required AccountID payout
}

struct ShopDetails {
    1: required string name
    2: optional string description
}

union ShopLocation {
    1: string url
}

/* Инспекция платежа */

enum RiskScore {
    low = 1
    high = 100
    fatal = 9999
}

/* Contracts */

struct ContractorRef { 1: required ObjectID id }

/** Лицо, выступающее стороной договора. */
union Contractor {
    1: LegalEntity legal_entity
    2: RegisteredUser registered_user
}

struct RegisteredUser {
    1: required string email
}

union LegalEntity {
    1: RussianLegalEntity russian_legal_entity
    2: InternationalLegalEntity international_legal_entity
}

/** Юридическое лицо-резидент РФ */
struct RussianLegalEntity {
    /* Наименование */
    1: required string registered_name
    /* ОГРН */
    2: required string registered_number
    /* ИНН/КПП */
    3: required string inn
    /* Адрес места нахождения */
    4: required string actual_address
    /* Адрес для отправки корреспонденции (почтовый) */
    5: required string post_address
    /* Наименование должности ЕИО/представителя */
    6: required string representative_position
    /* ФИО ЕИО/представителя */
    7: required string representative_full_name
    /* Наименование документа, на основании которого действует ЕИО/представитель */
    8: required string representative_document
    /* Реквизиты юр.лица */
    9: required RussianBankAccount russian_bank_account
}

struct InternationalLegalEntity {
    /* Наименование */
    1: required string legal_name
    /* Торговое наименование (если применимо) */
    2: optional string trading_name
    /* Адрес места регистрации */
    3: required string registered_address
    /* Адрес места нахождения (если отличается от регистрации)*/
    4: optional string actual_address
}

/** Банковский счёт. */

struct RussianBankAccount {
    1: required string account
    2: required string bank_name
    3: required string bank_post_account
    4: required string bank_bik
}

struct InternationalBankAccount {
    1: required string account_holder
    2: required string bank_name
    3: required string bank_address
    4: required string iban     // International Bank Account Number (ISO 13616)
    5: required string bic      // Business Identifier Code (ISO 9362)
}

typedef base.ID PayoutToolID

struct PayoutTool {
    1: required PayoutToolID id
    4: required base.Timestamp created_at
    2: required CurrencyRef currency
    3: required PayoutToolInfo payout_tool_info
}

union PayoutToolInfo {
    1: RussianBankAccount russian_bank_account
    2: InternationalBankAccount international_bank_account
}

typedef base.ID ContractID

/** Договор */
struct Contract {
    1: required ContractID id
    3: optional Contractor contractor
    12: optional PaymentInstitutionRef payment_institution
    11: required base.Timestamp created_at
    4: optional base.Timestamp valid_since
    5: optional base.Timestamp valid_until
    6: required ContractStatus status
    7: required TermSetHierarchyRef terms
    8: required list<ContractAdjustment> adjustments
    9: required list<PayoutTool> payout_tools
    10: optional LegalAgreement legal_agreement
}

/** Юридическое соглашение */
struct LegalAgreement {
    1: required base.Timestamp signed_at
    2: required string legal_agreement_id
}

union ContractStatus {
    1: ContractActive active
    2: ContractTerminated terminated
    3: ContractExpired expired
}

struct ContractActive {}
struct ContractTerminated { 1: required base.Timestamp terminated_at }
struct ContractExpired {}

/* Categories */

struct CategoryRef { 1: required ObjectID id }

enum CategoryType {
    test
    live
}

/** Категория продаваемых товаров или услуг. */
struct Category {
    1: required string name
    2: required string description
    3: optional CategoryType type = CategoryType.test
}

struct ContractTemplateRef { 1: required ObjectID id }

/** Шаблон договора или поправки **/
struct ContractTemplate {
    4: optional string name
    5: optional string description
    1: optional Lifetime valid_since
    2: optional Lifetime valid_until
    3: required TermSetHierarchyRef terms
}

union Lifetime {
    1: base.Timestamp timestamp
    2: LifetimeInterval interval
}

struct LifetimeInterval {
    1: optional i16 years
    2: optional i16 months
    3: optional i16 days
}

union ContractTemplateSelector {
    1: list<ContractTemplateDecision> decisions
    2: ContractTemplateRef value
}

struct ContractTemplateDecision {
    1: required Predicate if_
    2: required ContractTemplateSelector then_
}

/** Поправки к договору **/
typedef base.ID ContractAdjustmentID

struct ContractAdjustment {
    1: required ContractAdjustmentID id
    5: required base.Timestamp created_at
    2: optional base.Timestamp valid_since
    3: optional base.Timestamp valid_until
    4: required TermSetHierarchyRef terms
}

/** Условия **/
// Service
//   Payments
//     Regular
//     Held
//     Recurring
//     ...
//   Payouts
//   ...

struct TermSet {
    1: optional PaymentsServiceTerms payments
    2: optional RecurrentPaytoolsServiceTerms recurrent_paytools
    3: optional PayoutsServiceTerms payouts
}

struct TimedTermSet {
    1: required base.TimestampInterval action_time
    2: required TermSet terms
}

struct TermSetHierarchy {
    3: optional string name
    4: optional string description
    1: optional TermSetHierarchyRef parent_terms
    2: required list<TimedTermSet> term_sets
}

struct TermSetHierarchyRef { 1: required ObjectID id }

/* Payments service terms */

struct PaymentsServiceTerms {
    /* Shop level */
    // TODO It looks like you belong to the better place, something they call `AccountsServiceTerms`.
    1: optional CurrencySelector currencies
    2: optional CategorySelector categories
    /* Invoice level*/
    4: optional PaymentMethodSelector payment_methods
    5: optional CashLimitSelector cash_limit
    /* Payment level */
    6: optional CashFlowSelector fees
    9: optional PaymentHoldsServiceTerms holds
    8: optional PaymentRefundsServiceTerms refunds
}

struct PaymentHoldsServiceTerms {
    1: optional PaymentMethodSelector payment_methods
    2: optional HoldLifetimeSelector lifetime
}

struct PaymentRefundsServiceTerms {
    1: optional PaymentMethodSelector payment_methods
    2: optional CashFlowSelector fees
}

/* Recurrent payment tools service terms */

struct RecurrentPaytoolsServiceTerms {
    1: optional PaymentMethodSelector payment_methods
}

/* Payouts service terms */

struct PayoutsServiceTerms {
    /* Payout schedule level */
    4: optional ScheduleSelector payout_schedules
    /* Payout level */
    1: optional PayoutMethodSelector payout_methods
    2: optional CashLimitSelector cash_limit
    3: optional CashFlowSelector fees
}

struct PayoutCompilationPolicy {
    1: required base.TimeSpan assets_freeze_for
}

/* Payout methods */

enum PayoutMethod {
    russian_bank_account
    international_bank_account
}

struct PayoutMethodRef { 1: required PayoutMethod id }

/** Способ вывода, категория средства вывода. */
struct PayoutMethodDefinition {
    1: required string name
    2: required string description
}

union PayoutMethodSelector {
    1: list<PayoutMethodDecision> decisions
    2: set<PayoutMethodRef> value
}

struct PayoutMethodDecision {
    1: required Predicate if_
    2: required PayoutMethodSelector then_
}

/* Currencies */

/** Символьный код, уникально идентифицирующий валюту. */
typedef string CurrencySymbolicCode

struct CurrencyRef { 1: required CurrencySymbolicCode symbolic_code }

/** Валюта. */
struct Currency {
    1: required string name
    2: required CurrencySymbolicCode symbolic_code
    3: required i16 numeric_code
    4: required i16 exponent
}

union CurrencySelector {
    1: list<CurrencyDecision> decisions
    2: set<CurrencyRef> value
}

struct CurrencyDecision {
    1: required Predicate if_
    2: required CurrencySelector then_
}

/* Категории */

union CategorySelector {
    1: list<CategoryDecision> decisions
    2: set<CategoryRef> value
}

struct CategoryDecision {
    1: required Predicate if_
    2: required CategorySelector then_
}

/* Резиденция */
// Для обозначения спользуется alpha-3 код по стандарту ISO_3166-1
// https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3

enum Residence {
    ABH /*Abkhazia*/
    AUS /*Australia*/
    AUT /*Austria*/
    AZE /*Azerbaijan*/
    ALB /*Albania*/
    DZA /*Algeria*/
    ASM /*American Samoa*/
    AIA /*Anguilla*/
    AGO /*Angola*/
    AND /*Andorra*/
    ATA /*Antarctica*/
    ATG /*Antigua and Barbuda*/
    ARG /*Argentina*/
    ARM /*Armenia*/
    ABW /*Aruba*/
    AFG /*Afghanistan*/
    BHS /*Bahamas*/
    BGD /*Bangladesh*/
    BRB /*Barbados*/
    BHR /*Bahrain*/
    BLR /*Belarus*/
    BLZ /*Belize*/
    BEL /*Belgium*/
    BEN /*Benin*/
    BMU /*Bermuda*/
    BGR /*Bulgaria*/
    BOL /*Bolivia, plurinational state of*/
    BES /*Bonaire, Sint Eustatius and Saba*/
    BIH /*Bosnia and Herzegovina*/
    BWA /*Botswana*/
    BRA /*Brazil*/
    IOT /*British Indian Ocean Territory*/
    BRN /*Brunei Darussalam*/
    BFA /*Burkina Faso*/
    BDI /*Burundi*/
    BTN /*Bhutan*/
    VUT /*Vanuatu*/
    HUN /*Hungary*/
    VEN /*Venezuela*/
    VGB /*Virgin Islands, British*/
    VIR /*Virgin Islands, U.S.*/
    VNM /*Vietnam*/
    GAB /*Gabon*/
    HTI /*Haiti*/
    GUY /*Guyana*/
    GMB /*Gambia*/
    GHA /*Ghana*/
    GLP /*Guadeloupe*/
    GTM /*Guatemala*/
    GIN /*Guinea*/
    GNB /*Guinea-Bissau*/
    DEU /*Germany*/
    GGY /*Guernsey*/
    GIB /*Gibraltar*/
    HND /*Honduras*/
    HKG /*Hong Kong*/
    GRD /*Grenada*/
    GRL /*Greenland*/
    GRC /*Greece*/
    GEO /*Georgia*/
    GUM /*Guam*/
    DNK /*Denmark*/
    JEY /*Jersey*/
    DJI /*Djibouti*/
    DMA /*Dominica*/
    DOM /*Dominican Republic*/
    EGY /*Egypt*/
    ZMB /*Zambia*/
    ESH /*Western Sahara*/
    ZWE /*Zimbabwe*/
    ISR /*Israel*/
    IND /*India*/
    IDN /*Indonesia*/
    JOR /*Jordan*/
    IRQ /*Iraq*/
    IRN /*Iran, Islamic Republic of*/
    IRL /*Ireland*/
    ISL /*Iceland*/
    ESP /*Spain*/
    ITA /*Italy*/
    YEM /*Yemen*/
    CPV /*Cape Verde*/
    KAZ /*Kazakhstan*/
    KHM /*Cambodia*/
    CMR /*Cameroon*/
    CAN /*Canada*/
    QAT /*Qatar*/
    KEN /*Kenya*/
    CYP /*Cyprus*/
    KGZ /*Kyrgyzstan*/
    KIR /*Kiribati*/
    CHN /*China*/
    CCK /*Cocos (Keeling) Islands*/
    COL /*Colombia*/
    COM /*Comoros*/
    COG /*Congo*/
    COD /*Congo, Democratic Republic of the*/
    PRK /*Korea, Democratic People's republic of*/
    KOR /*Korea, Republic of*/
    CRI /*Costa Rica*/
    CIV /*Cote d'Ivoire*/
    CUB /*Cuba*/
    KWT /*Kuwait*/
    CUW /*Curaçao*/
    LAO /*Lao People's Democratic Republic*/
    LVA /*Latvia*/
    LSO /*Lesotho*/
    LBN /*Lebanon*/
    LBY /*Libyan Arab Jamahiriya*/
    LBR /*Liberia*/
    LIE /*Liechtenstein*/
    LTU /*Lithuania*/
    LUX /*Luxembourg*/
    MUS /*Mauritius*/
    MRT /*Mauritania*/
    MDG /*Madagascar*/
    MYT /*Mayotte*/
    MAC /*Macao*/
    MWI /*Malawi*/
    MYS /*Malaysia*/
    MLI /*Mali*/
    UMI /*United States Minor Outlying Islands*/
    MDV /*Maldives*/
    MLT /*Malta*/
    MAR /*Morocco*/
    MTQ /*Martinique*/
    MHL /*Marshall Islands*/
    MEX /*Mexico*/
    FSM /*Micronesia, Federated States of*/
    MOZ /*Mozambique*/
    MDA /*Moldova*/
    MCO /*Monaco*/
    MNG /*Mongolia*/
    MSR /*Montserrat*/
    MMR /*Burma*/
    NAM /*Namibia*/
    NRU /*Nauru*/
    NPL /*Nepal*/
    NER /*Niger*/
    NGA /*Nigeria*/
    NLD /*Netherlands*/
    NIC /*Nicaragua*/
    NIU /*Niue*/
    NZL /*New Zealand*/
    NCL /*New Caledonia*/
    NOR /*Norway*/
    ARE /*United Arab Emirates*/
    OMN /*Oman*/
    BVT /*Bouvet Island*/
    IMN /*Isle of Man*/
    NFK /*Norfolk Island*/
    CXR /*Christmas Island*/
    HMD /*Heard Island and McDonald Islands*/
    CYM /*Cayman Islands*/
    COK /*Cook Islands*/
    TCA /*Turks and Caicos Islands*/
    PAK /*Pakistan*/
    PLW /*Palau*/
    PSE /*Palestinian Territory, Occupied*/
    PAN /*Panama*/
    VAT /*Holy See (Vatican City State)*/
    PNG /*Papua New Guinea*/
    PRY /*Paraguay*/
    PER /*Peru*/
    PCN /*Pitcairn*/
    POL /*Poland*/
    PRT /*Portugal*/
    PRI /*Puerto Rico*/
    MKD /*Macedonia, The Former Yugoslav Republic Of*/
    REU /*Reunion*/
    RUS /*Russian Federation*/
    RWA /*Rwanda*/
    ROU /*Romania*/
    WSM /*Samoa*/
    SMR /*San Marino*/
    STP /*Sao Tome and Principe*/
    SAU /*Saudi Arabia*/
    SWZ /*Swaziland*/
    SHN /*Saint Helena, Ascension And Tristan Da Cunha*/
    MNP /*Northern Mariana Islands*/
    BLM /*Saint Barthélemy*/
    MAF /*Saint Martin (French Part)*/
    SEN /*Senegal*/
    VCT /*Saint Vincent and the Grenadines*/
    KNA /*Saint Kitts and Nevis*/
    LCA /*Saint Lucia*/
    SPM /*Saint Pierre and Miquelon*/
    SRB /*Serbia*/
    SYC /*Seychelles*/
    SGP /*Singapore*/
    SXM /*Sint Maarten*/
    SYR /*Syrian Arab Republic*/
    SVK /*Slovakia*/
    SVN /*Slovenia*/
    GBR /*United Kingdom*/
    USA /*United States*/
    SLB /*Solomon Islands*/
    SOM /*Somalia*/
    SDN /*Sudan*/
    SUR /*Suriname*/
    SLE /*Sierra Leone*/
    TJK /*Tajikistan*/
    THA /*Thailand*/
    TWN /*Taiwan, Province of China*/
    TZA /*Tanzania, United Republic Of*/
    TLS /*Timor-Leste*/
    TGO /*Togo*/
    TKL /*Tokelau*/
    TON /*Tonga*/
    TTO /*Trinidad and Tobago*/
    TUV /*Tuvalu*/
    TUN /*Tunisia*/
    TKM /*Turkmenistan*/
    TUR /*Turkey*/
    UGA /*Uganda*/
    UZB /*Uzbekistan*/
    UKR /*Ukraine*/
    WLF /*Wallis and Futuna*/
    URY /*Uruguay*/
    FRO /*Faroe Islands*/
    FJI /*Fiji*/
    PHL /*Philippines*/
    FIN /*Finland*/
    FLK /*Falkland Islands (Malvinas)*/
    FRA /*France*/
    GUF /*French Guiana*/
    PYF /*French Polynesia*/
    ATF /*French Southern Territories*/
    HRV /*Croatia*/
    CAF /*Central African Republic*/
    TCD /*Chad*/
    MNE /*Montenegro*/
    CZE /*Czech Republic*/
    CHL /*Chile*/
    CHE /*Switzerland*/
    SWE /*Sweden*/
    SJM /*Svalbard and Jan Mayen*/
    LKA /*Sri Lanka*/
    ECU /*Ecuador*/
    GNQ /*Equatorial Guinea*/
    ALA /*Aland Islands*/
    SLV /*El Salvador*/
    ERI /*Eritrea*/
    EST /*Estonia*/
    ETH /*Ethiopia*/
    ZAF /*South Africa*/
    SGS /*South Georgia and the South Sandwich Islands*/
    OST /*South Ossetia*/
    SSD /*South Sudan*/
    JAM /*Jamaica*/
    JPN /*Japan*/
}

/* Schedules */

struct ScheduleRef { 1: required ObjectID id }

struct Schedule {
    1: required string name
    2: optional string description
    3: required base.Schedule schedule
    4: required PayoutCompilationPolicy policy
}

union ScheduleSelector {
    1: list<ScheduleDecision> decisions
    2: set<ScheduleRef> value
}

struct ScheduleDecision {
    1: required Predicate if_
    2: required ScheduleSelector then_
}

/* Calendars */

struct CalendarRef { 1: required ObjectID id }

struct Calendar {
    1: required string name
    2: optional string description
    3: required base.Timezone timezone
    4: required CalendarHolidaySet holidays
}

typedef map<base.Year, set<CalendarHoliday>> CalendarHolidaySet

struct CalendarHoliday {
    1: required string name
    2: optional string description
    3: required base.DayOfMonth day
    4: required base.Month month
}

/* Limits */

struct CashRange {
    1: required CashBound upper
    2: required CashBound lower
}

union CashBound {
    1: Cash inclusive
    2: Cash exclusive
}

union CashLimitSelector {
    1: list<CashLimitDecision> decisions
    2: CashRange value
}

struct CashLimitDecision {
    1: required Predicate if_
    2: required CashLimitSelector then_
}

/* Payment methods */

union PaymentMethod {
    1: BankCardPaymentSystem bank_card
    2: TerminalPaymentProvider payment_terminal
    3: DigitalWalletProvider digital_wallet
}

enum BankCardPaymentSystem {
    visa
    mastercard
    visaelectron
    maestro
    forbrugsforeningen
    dankort
    amex
    dinersclub
    discover
    unionpay
    jcb
    nspkmir
}

typedef base.ID CustomerID
typedef base.ID CustomerBindingID
typedef base.ID RecurrentPaymentToolID

union PaymentTool {
    1: BankCard bank_card
    2: PaymentTerminal payment_terminal
    3: DigitalWallet digital_wallet
}

struct DisposablePaymentResource {
    1: required PaymentTool      payment_tool
    2: optional PaymentSessionID payment_session_id
    3: required ClientInfo       client_info
}

typedef string Token

struct BankCard {
    1: required Token token
    2: required BankCardPaymentSystem payment_system
    3: required string bin
    4: required string masked_pan
}

/** Платеж через терминал **/
struct PaymentTerminal {
    1: required TerminalPaymentProvider terminal_type
}

/**
*  Вид платежного терминала
*
*  например Евросеть
**/
enum TerminalPaymentProvider {
    euroset
}

typedef string DigitalWalletID

struct DigitalWallet {
    1: required DigitalWalletProvider provider
    2: required DigitalWalletID       id
}

enum DigitalWalletProvider {
    qiwi
}

struct BankCardBINRangeRef { 1: required ObjectID id }

struct BankCardBINRange {
    1: required string name
    2: required string description
    3: required set<string> bins
}

struct PaymentMethodRef { 1: required PaymentMethod id }

/** Способ платежа, категория платёжного средства. */
struct PaymentMethodDefinition {
    1: required string name
    2: required string description
}

union PaymentMethodSelector {
    1: list<PaymentMethodDecision> decisions
    2: set<PaymentMethodRef> value
}

struct PaymentMethodDecision {
    1: required Predicate if_
    2: required PaymentMethodSelector then_
}

/* Holds */

struct HoldLifetime {
    1: required i32 seconds
}

union HoldLifetimeSelector {
    1: list<HoldLifetimeDecision> decisions
    2: HoldLifetime value
}

struct HoldLifetimeDecision {
    1: required Predicate if_
    2: required HoldLifetimeSelector then_
}

/* Flows */

// TODO

/* Cash flows */

/** Счёт в графе финансовых потоков. */
union CashFlowAccount {
    1: MerchantCashFlowAccount merchant
    2: ProviderCashFlowAccount provider
    3: SystemCashFlowAccount system
    4: ExternalCashFlowAccount external
}

enum MerchantCashFlowAccount {

    /**
     * Расчётный счёт:
     *  - учёт прибыли по платежам в магазине;
     *  - учёт возмещённых вознаграждений.
     */
    settlement

    /**
     * Счёт гарантийного депозита:
     *  - учёт средств для погашения реализовавшихся рисков по мерчанту.
     */
    guarantee

}

enum ProviderCashFlowAccount {

    /**
     * Расчётный счёт:
     *  - учёт полученных средств;
     *  - учёт вознаграждений.
     */
    settlement

}

enum SystemCashFlowAccount {

    /**
     * Расчётный счёт:
     *  - учёт полученных и возмещённых вознаграждений.
     */
    settlement

}

enum ExternalCashFlowAccount {

    /**
     * Счёт поступлений:
     *  - учёт любых поступлений в систему извне.
     */
    income

    /**
     * Счёт выводов:
     *  - учёт любых выводов из системы вовне.
     */
    outcome

}

enum CashFlowConstant {
    operation_amount = 1
    // ...
    // TODO

    /* deprecated */
    // invoice_amount = 0
    // payment_amount = 1
}

typedef map<CashFlowConstant, Cash> CashFlowContext

/** Граф финансовых потоков. */
typedef list<CashFlowPosting> CashFlow

/** Денежный поток между двумя участниками. */
struct CashFlowPosting {
    1: required CashFlowAccount source
    2: required CashFlowAccount destination
    3: required CashVolume volume
    4: optional string details
}

/** Полностью вычисленный граф финансовых потоков с проводками всех участников. */
typedef list<FinalCashFlowPosting> FinalCashFlow

/** Вычисленный денежный поток между двумя участниками. */
struct FinalCashFlowPosting {
    1: required FinalCashFlowAccount source
    2: required FinalCashFlowAccount destination
    3: required Cash volume
    4: optional string details
}

struct FinalCashFlowAccount {
    1: required CashFlowAccount account_type
    2: required AccountID account_id
}

/** Объём финансовой проводки. */
union CashVolume {
    1: CashVolumeFixed fixed
    2: CashVolumeShare share
    3: CashVolumeProduct product
}

/** Объём в абсолютных денежных единицах. */
struct CashVolumeFixed {
    1: required Cash cash
}

/** Объём в относительных единицах. */
struct CashVolumeShare {
    1: required base.Rational parts
    2: required CashFlowConstant of
    3: optional RoundingMethod rounding_method
}

/** Метод округления к целому числу. */
enum RoundingMethod {
    /** https://en.wikipedia.org/wiki/Rounding#Round_half_towards_zero. */
    round_half_towards_zero
    /** https://en.wikipedia.org/wiki/Rounding#Round_half_away_from_zero. */
    round_half_away_from_zero
}

/** Композиция различных объёмов. */
union CashVolumeProduct {
    /** Минимальный из полученных объёмов. */
    1: set<CashVolume> min_of
    /** Максимальный из полученных объёмов. */
    2: set<CashVolume> max_of
}

union CashFlowSelector {
    1: list<CashFlowDecision> decisions
    2: CashFlow value
}

struct CashFlowDecision {
    1: required Predicate if_
    2: required CashFlowSelector then_
}

/* Providers */

struct ProviderRef { 1: required ObjectID id }

struct Provider {
    1: required string name
    2: required string description
    3: required Proxy proxy
    4: required TerminalSelector terminal
    /* Счет для платажей принятых эквайеромв АБС*/
    5: required string abs_account
    6: optional PaymentsProvisionTerms payment_terms
    8: optional RecurrentPaytoolsProvisionTerms recurrent_paytool_terms
    7: optional ProviderAccountSet accounts = {}
}

struct PaymentsProvisionTerms {
    1: required CurrencySelector currencies
    2: required CategorySelector categories
    3: required PaymentMethodSelector payment_methods
    6: required CashLimitSelector cash_limit
    4: required CashFlowSelector cash_flow
    5: optional PaymentHoldsProvisionTerms holds
    7: optional PaymentRefundsProvisionTerms refunds
}

struct PaymentHoldsProvisionTerms {
    1: required HoldLifetimeSelector lifetime
}

struct PaymentRefundsProvisionTerms {
    1: required CashFlowSelector cash_flow
}

struct RecurrentPaytoolsProvisionTerms {
    1: required CashValueSelector     cash_value
    2: required CategorySelector      categories
    3: required PaymentMethodSelector payment_methods
}

union CashValueSelector {
    1: list<CashValueDecision> decisions
    2: Cash value
}

struct CashValueDecision {
    1: required Predicate if_
    2: required CashValueSelector then_
}

typedef map<CurrencyRef, ProviderAccount> ProviderAccountSet

struct ProviderAccount {
    1: required AccountID settlement
}

union ProviderSelector {
    1: list<ProviderDecision> decisions
    2: set<ProviderRef> value
}

struct ProviderDecision {
    1: required Predicate if_
    2: required ProviderSelector then_
}

struct TerminalRef { 1: required ObjectID id }

/** Inspectors */

struct InspectorRef { 1: required ObjectID id }

struct Inspector {
    1: required string name
    2: required string description
    3: required Proxy proxy
}

union InspectorSelector {
    1: list<InspectorDecision> decisions
    2: InspectorRef value
}

struct InspectorDecision {
    1: required Predicate if_
    2: required InspectorSelector then_
}

/**
 * Обобщённый терминал у провайдера.
 *
 * Представляет собой единицу предоставления услуг по процессингу платежей со
 * стороны провайдера, согласно нашим с ним договорённостям.
 */
struct Terminal {
    1: required string name
    2: required string description
    9: optional ProxyOptions options
    10: required RiskScore risk_coverage
    12: optional PaymentsProvisionTerms terms
}

union TerminalSelector {
    1: list<TerminalDecision> decisions
    2: set<TerminalRef> value
}

struct TerminalDecision {
    1: required Predicate if_
    2: required TerminalSelector then_
}

/* Predicates / conditions */

union Predicate {
    5: bool constant
    1: Condition condition
    2: Predicate is_not
    3: set<Predicate> all_of
    4: set<Predicate> any_of
}

union Condition {
    1: CategoryRef category_is
    2: CurrencyRef currency_is
    4: CashRange cost_in
    3: PaymentToolCondition payment_tool
    5: ShopLocation shop_location_is
    6: PartyCondition party
    7: PayoutMethodRef payout_method_is
}

union PaymentToolCondition {
    1: BankCardCondition bank_card
    2: PaymentTerminalCondition payment_terminal
    3: DigitalWalletCondition digital_wallet
}

struct BankCardCondition {
    1: optional BankCardPaymentSystem payment_system_is // legacy
    2: optional BankCardBINRangeRef bin_in              // legacy
    3: optional BankCardConditionDefinition definition
}

union BankCardConditionDefinition {
    1: BankCardPaymentSystem payment_system_is
    2: BankCardBINRangeRef bin_in
}

struct PaymentTerminalCondition {
    1: optional PaymentTerminalConditionDefinition definition
}

union PaymentTerminalConditionDefinition {
    1: TerminalPaymentProvider provider_is
}

struct DigitalWalletCondition {
    1: optional DigitalWalletConditionDefinition definition
}

union DigitalWalletConditionDefinition {
    1: DigitalWalletProvider provider_is
}

struct PartyCondition {
    1: required PartyID id
    2: optional PartyConditionDefinition definition
}

union PartyConditionDefinition {
    1: ShopID shop_is
}

/* Proxies */

typedef base.StringMap ProxyOptions

struct ProxyRef { 1: required ObjectID id }

struct ProxyDefinition {
    1: required string name
    2: required string description
    3: required string url
    4: required ProxyOptions options
}

struct Proxy {
    1: required ProxyRef ref
    2: required ProxyOptions additional
}

/* System accounts */

struct SystemAccountSetRef { 1: required ObjectID id }

struct SystemAccountSet {
    1: required string name
    2: required string description
    3: required map<CurrencyRef, SystemAccount> accounts
}

struct SystemAccount {
    1: required AccountID settlement
}

union SystemAccountSetSelector {
    1: list<SystemAccountSetDecision> decisions
    2: SystemAccountSetRef value
}

struct SystemAccountSetDecision {
    1: required Predicate if_
    2: required SystemAccountSetSelector then_
}

/* External accounts */

struct ExternalAccountSetRef { 1: required ObjectID id }

struct ExternalAccountSet {
    1: required string name
    2: required string description
    3: required map<CurrencyRef, ExternalAccount> accounts
}

struct ExternalAccount {
    1: required AccountID income
    2: required AccountID outcome
}

union ExternalAccountSetSelector {
    1: list<ExternalAccountSetDecision> decisions
    2: ExternalAccountSetRef value
}

struct ExternalAccountSetDecision {
    1: required Predicate if_
    2: required ExternalAccountSetSelector then_
}

/* Payment institution */

struct PaymentInstitutionRef { 1: required ObjectID id }

struct PaymentInstitution {
    1: required string name
    2: optional string description
    9: optional CalendarRef calendar
    3: required SystemAccountSetSelector system_account_set
    4: required ContractTemplateSelector default_contract_template
    5: required ProviderSelector providers
    6: required InspectorSelector inspector
    7: required PaymentInstitutionRealm realm
    8: required set<Residence> residences
}

enum PaymentInstitutionRealm {
    test
    live
}

struct ContractPaymentInstitutionDefaults {
    1: required PaymentInstitutionRef test
    2: required PaymentInstitutionRef live
}

/* Merchant, shop, contract & payout_tool prototypes */
/* all deprecated */

struct PartyPrototypeRef { 1: required ObjectID id }

struct PartyPrototype {
    1: required ShopPrototype shop
    3: required ContractPrototype contract
}

struct ShopPrototype {
    5: required ShopID shop_id
    1: required CategoryRef category
    2: required CurrencyRef currency
    3: required ShopDetails details
    4: required ShopLocation location
}

struct ContractPrototype {
    1: required ContractID contract_id
    2: required ContractTemplateRef test_contract_template
    3: required PayoutToolPrototype payout_tool
}

struct PayoutToolPrototype {
    1: required PayoutToolID payout_tool_id
    2: required PayoutToolInfo payout_tool_info
    3: required CurrencyRef payout_tool_currency
}

/* Root config */

struct GlobalsRef {}

struct Globals {

    4: required ExternalAccountSetSelector external_account_set
    8: optional set<PaymentInstitutionRef> payment_institutions
    42: optional ContractPaymentInstitutionDefaults contract_payment_institution_defaults

    /* deprecated */
    1: optional PartyPrototypeRef party_prototype
    2: optional ProviderSelector providers
    3: optional SystemAccountSetSelector system_account_set
    5: optional InspectorSelector inspector
    6: optional ContractTemplateRef default_contract_template
    7: optional ProxyRef common_merchant_proxy
}

/** Dummy (for integrity test purpose) */
struct Dummy {}

struct DummyRef {
    1: base.ID id
}

struct DummyObject {
    1: DummyRef ref
    2: Dummy data
}

struct DummyLink {
    1: DummyRef link
}

struct DummyLinkRef {
    1: base.ID id
}

struct DummyLinkObject {
    1: DummyLinkRef ref
    2: DummyLink data
}

/* Type enumerations */

struct ContractTemplateObject {
    1: required ContractTemplateRef ref
    2: required ContractTemplate data
}

struct TermSetHierarchyObject {
    1: required TermSetHierarchyRef ref
    2: required TermSetHierarchy data
}

struct CategoryObject {
    1: required CategoryRef ref
    2: required Category data
}

struct CurrencyObject {
    1: required CurrencyRef ref
    2: required Currency data
}

struct ScheduleObject {
    1: required ScheduleRef ref
    2: required Schedule data
}

struct CalendarObject {
    1: required CalendarRef ref
    2: required Calendar data
}

struct PaymentMethodObject {
    1: required PaymentMethodRef ref
    2: required PaymentMethodDefinition data
}

struct PayoutMethodObject {
    1: required PayoutMethodRef ref
    2: required PayoutMethodDefinition data
}

struct BankCardBINRangeObject {
    1: required BankCardBINRangeRef ref
    2: required BankCardBINRange data
}

struct ContractorObject {
    1: required ContractorRef ref
    2: required Contractor data
}

struct ProviderObject {
    1: required ProviderRef ref
    2: required Provider data
}

struct TerminalObject {
    1: required TerminalRef ref
    2: required Terminal data
}

struct InspectorObject {
    1: required InspectorRef ref
    2: required Inspector data
}

struct PaymentInstitutionObject {
    1: required PaymentInstitutionRef ref
    2: required PaymentInstitution data
}

struct SystemAccountSetObject {
    1: required SystemAccountSetRef ref
    2: required SystemAccountSet data
}

struct ExternalAccountSetObject {
    1: required ExternalAccountSetRef ref
    2: required ExternalAccountSet data
}

struct ProxyObject {
    1: required ProxyRef ref
    2: required ProxyDefinition data
}

/* deprecated */
struct PartyPrototypeObject {
    1: required PartyPrototypeRef ref
    2: required PartyPrototype data
}

struct GlobalsObject {
    1: required GlobalsRef ref
    2: required Globals data
}

union Reference {

    1  : CategoryRef             category
    2  : CurrencyRef             currency
    19 : ScheduleRef             schedule
    20 : CalendarRef             calendar
    3  : PaymentMethodRef        payment_method
    21 : PayoutMethodRef         payout_method
    4  : ContractorRef           contractor
    5  : BankCardBINRangeRef     bank_card_bin_range
    6  : ContractTemplateRef     contract_template
    17 : TermSetHierarchyRef     term_set_hierarchy
    18 : PaymentInstitutionRef   payment_institution
    7  : ProviderRef             provider
    8  : TerminalRef             terminal
    15 : InspectorRef            inspector
    14 : SystemAccountSetRef     system_account_set
    16 : ExternalAccountSetRef   external_account_set
    9  : ProxyRef                proxy
    11 : GlobalsRef              globals

    12 : DummyRef                dummy
    13 : DummyLinkRef            dummy_link

    /* deprecated */
    10 : PartyPrototypeRef       party_prototype
}

union DomainObject {

    1  : CategoryObject             category
    2  : CurrencyObject             currency
    19 : ScheduleObject             schedule
    20 : CalendarObject             calendar
    3  : PaymentMethodObject        payment_method
    21 : PayoutMethodObject         payout_method
    4  : ContractorObject           contractor
    5  : BankCardBINRangeObject     bank_card_bin_range
    6  : ContractTemplateObject     contract_template
    17 : TermSetHierarchyObject     term_set_hierarchy
    18 : PaymentInstitutionObject   payment_institution
    7  : ProviderObject             provider
    8  : TerminalObject             terminal
    15 : InspectorObject            inspector
    14 : SystemAccountSetObject     system_account_set
    16 : ExternalAccountSetObject   external_account_set
    9  : ProxyObject                proxy
    11 : GlobalsObject              globals

    12 : DummyObject                dummy
    13 : DummyLinkObject            dummy_link

    /* deprecated */
    10 : PartyPrototypeObject       party_prototype
}

/* Domain */

typedef map<Reference, DomainObject> Domain
