class Campaign {
  final String id, title, category, image, organization;
  final double raised, goal;
  const Campaign(
    this.id,
    this.title,
    this.category,
    this.image, {
    this.organization = 'Save Children',
    this.raised = 1989.99,
    this.goal = 2990,
  });
}

const categories = [
  'Hurricane Relief',
  'Disaster Relief',
  'Shelter & Housing',
  'Global Impact',
  'Hunger Relief',
  'War Support',
];

const campaigns = [
  Campaign('harvey', 'Hurricane Relief Support', 'Hurricane Relief', 'flood'),
  Campaign('rebuild', 'Help Families Rebuild', 'Shelter & Housing', 'house'),
  Campaign(
    'disaster',
    'Disaster Relief',
    'Disaster Relief',
    'disaster',
    organization: 'The Giving Tree Foundation',
  ),
  Campaign(
    'community',
    'Rebuild Our Community',
    'Global Impact',
    'nearby-house',
  ),
  Campaign(
    'emergency',
    'Emergency Family Support',
    'War Support',
    'nearby-car',
  ),
  Campaign('food', 'Food for Every Family', 'Hunger Relief', 'flood'),
];

class Donation {
  final String id, campaignId, title, frequency, message, card;
  final double amount;
  final DateTime date;
  const Donation({
    required this.id,
    required this.campaignId,
    required this.title,
    required this.frequency,
    required this.message,
    required this.card,
    required this.amount,
    required this.date,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'campaignId': campaignId,
    'title': title,
    'frequency': frequency,
    'message': message,
    'card': card,
    'amount': amount,
    'date': date.toIso8601String(),
  };
  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
    id: json['id'],
    campaignId: json['campaignId'],
    title: json['title'],
    frequency: json['frequency'],
    message: json['message'],
    card: json['card'],
    amount: (json['amount'] as num).toDouble(),
    date: DateTime.parse(json['date']),
  );
}
