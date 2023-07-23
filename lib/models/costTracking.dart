class CostTracking {
  int id;
  int contextCount;
  double estimatedCost;
  String createdAt;

  CostTracking({
    required this.id,
    required this.contextCount,
    required this.estimatedCost,
    required this.createdAt,
  });

  static CostTracking fromMap(Map<String, dynamic> map) {
    return CostTracking(
      id: map['id'],
      contextCount: map['context_count'],
      estimatedCost: map['estimated_cost'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'context_count': contextCount,
      'estimated_cost': estimatedCost,
      'created_at': createdAt,
    };
  }
}
