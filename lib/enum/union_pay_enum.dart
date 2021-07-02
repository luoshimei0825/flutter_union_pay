/// 支付结果状态
enum PaymentResultStatus {
  cancel,   // 支付取消
  success,  // 支付成功
  failure,  // 支付失败
}

/// 支付环境
///
/// PRODUCT = '00';
/// DEVELOPMENT ='01';
///
enum PaymentMode {
  // 生产环境
  product,

  // 测试环境
  development,
}