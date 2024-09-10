class PaymentCards {
  var id,
      object,
      billing_details,
      card,
      country,
      created,
      customer,
      livemode,
      metadata,
      type;

  PaymentCards._({
    this.id,
    this.object,
    this.billing_details,
    this.card,
    this.country,
    this.created,
    this.customer,
    this.livemode,
    this.metadata,
    this.type,
  });

  factory PaymentCards.fromJson(Map<String, dynamic> json) {
    return new PaymentCards._(
      id: json['id'],
      object: json['object'],
      billing_details: json['billing_details'],
      card: json['card'],
      country: json['country'],
      created: json['created'],
      customer: json['customer'],
      livemode: json['livemode'],
      metadata: json['metadata'],
      type: json['type'],
    );
  }
}
