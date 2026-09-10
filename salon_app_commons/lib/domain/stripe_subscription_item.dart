class StripeSubscriptionItem {
  final String plan;
  final String price;

  StripeSubscriptionItem._(
    this.plan,
    this.price,
  );

  factory StripeSubscriptionItem.json(Map data) {
    return StripeSubscriptionItem._(
      data['plan'] ?? '',
      data['price'] ?? '',
    );
  }
}
