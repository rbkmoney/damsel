include "base.thrift"
include "domain.thrift"

typedef base.Opaque ProxyState

union Intent {
	1: FinishIntent finish
	2: SleepIntent sleep
}

union FinishStatus {
	1: base.Ok ok
	2: base.Error failure
}

struct FinishIntent {
	1: required FinishStatus status
}

struct SleepIntent {
	1: required base.Timer timer
}

struct PaymentInfo {
	1: required domain.Invoice invoice
	2: required domain.InvoicePayment payment
	3: required domain.ProxyOptions options
	4: optional ProxyState state
}

struct ProcessResult {
	1: required Intent intent
	2: optional domain.TransactionInfo trx
	3: optional ProxyState next_state
}

service ProviderProxy {

	ProcessResult ProcessPayment (1: PaymentInfo payment)
		throws (1: base.TryLater ex1)

	ProcessResult CapturePayment (1: PaymentInfo payment)
		throws (1: base.TryLater ex1)

	ProcessResult CancelPayment (1: PaymentInfo payment)
		throws (1: base.TryLater ex1)

	// TODO: discuss that shit
	// void ValidateOptions (1: domain.ProxyOptions options)
	// 	throws (1: InvalidProxyOptions ex1)

}
