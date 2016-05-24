include "base.thrift"
include "domain.thrift"

union PaymentTool {
	1: cds.CardData card_data
}

struct TDSData {
	1: map<string, string> data
}

/** could be opaque */
struct AuthorizationData {
	1: string trx_id
	2: optional string session
}

service PaymentProxy {
	AuthorizationData Payment (1: domain.Invoice invoice, 2: PaymentTool tool, 3: TDSData tds) 
		throws (1: base.Failure fail, 2: base.TryLater later)
	void Cancel (1: AuthorizationData auth)
		throws (1: base.Failure fail, 2: base.TryLater later)
	AuthorizationData Refund (1: domain.Invoice invoice, 2: PaymentTool tool)
		throws (1: base.Failure fail, 2: base.TryLater later)
	AuthorizationData Preauth (1: domain.Invoice invoice, 2: PaymentTool tool, 3: TDSData tds)
		throws (1: base.Failure fail, 2: base.TryLater later)
	AuthorizationData Complete (1: domain.Invoice invoice, 2: PaymentTool tool, 3: AuthorizationData auth)
		throws (1: base.Failure fail, 2: base.TryLater later)

}