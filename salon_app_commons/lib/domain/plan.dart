import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:salon_app_commons/i18n/strings.g.dart';

import 'interval_type.dart';
import 'plan_type.dart';
import 'price.dart';

/// プラン
class Plan {
  final String? id;
  final bool? active;
  final String? description;
  final String? imageUrl;
  final String? name;
  final Map metadata;
  final List<Price> availablePrices; // 月額、年額が存在する

  Plan._(
    this.id,
    this.active,
    this.description,
    this.imageUrl,
    this.name,
    this.metadata,
    this.availablePrices,
  );

  factory Plan.doc(DocumentSnapshot doc, List<Price> prices) {
    final data = doc.data() as Map;

    String? imageUrl;
    if (data['images'] is List<dynamic> && data['images'].length > 0 && data['images'][0] is String) {
      imageUrl = data['images'][0];
    }

    return Plan._(
      doc.id,
      data['active'] ?? false,
      data['description'] ?? '',
      imageUrl,
      data['name'] ?? '',
      data['metadata'],
      prices,
    );
  }

  Price? getPrice(IntervalType intervalType) {
    return availablePrices.firstWhereOrNull((price) => price.intervalType == intervalType);
  }

  PlanType get planType {
    switch (name) {
      case 'コミュニティプラン':
      case 'コミュニティプラン(テックフォード割引)':
        return PlanType.community;
      case '課題学習プラン':
      case '課題学習プラン(テックフォード割引)':
      case '課題学習プラン(割引)':
        return PlanType.learning;
      case '無料プラン':
        return PlanType.free;
      case 'ライト修行プラン':
        return PlanType.trainingLight;
      case 'AI修行プラン':
        return PlanType.aiTraining;
      default: // それ以外はFlutter修行プラン（過去を含める結構いっぱいある）
        return PlanType.training;
    }
  }

  String get nameLocalized {
    switch (planType) {
      case PlanType.community:
        return t.plan.community;
      case PlanType.learning:
        return t.plan.learning;
      case PlanType.trainingLight:
        return t.plan.trainingLight;
      case PlanType.training:
        return t.plan.training;
      case PlanType.aiTraining:
        return t.plan.aiTraining;
      default:
        return name ?? '';
    }
  }

  IconData get icon {
    switch (planType) {
      case PlanType.community:
        return Icons.person;
      case PlanType.learning:
        return Icons.school;
      case PlanType.trainingLight:
        return Icons.local_fire_department;
      case PlanType.training:
        return Icons.local_fire_department;
      case PlanType.aiTraining:
        return Icons.smart_toy;
      default:
        return Icons.smartphone_rounded;
    }
  }

  String get lPDescription {
    switch (planType) {
      case PlanType.community:
        return t.price.lPDescription.community;
      case PlanType.learning:
        return t.price.lPDescription.learning;
      case PlanType.trainingLight:
        return t.price.lPDescription.trainingLight;
      case PlanType.training:
        return t.price.lPDescription.training;
      case PlanType.aiTraining:
        return t.price.lPDescription.aiTraining;
      default:
        return '';
    }
  }

  String get lPFeature {
    switch (planType) {
      case PlanType.community:
        return t.price.lPFeature1;
      case PlanType.learning:
        return t.price.lPFeature2;
      case PlanType.trainingLight:
        return t.price.lPFeature3;
      case PlanType.training:
        return t.price.lPFeature4;
      case PlanType.aiTraining:
        return t.price.lPFeature5;
      default:
        return '';
    }
  }

  String get moreLinkURL {
    switch (planType) {
      case PlanType.community:
        return 'https://blog.flutteruniv.com/flutteruniv-community-plan/';
      case PlanType.learning:
        return 'https://blog.flutteruniv.com/flutteruniv-task-learning-plan/';
      case PlanType.trainingLight:
      case PlanType.training:
        return 'https://blog.flutteruniv.com/flutteruniv-flutter-training-plan/';
      case PlanType.aiTraining:
        return 'https://blog.flutteruniv.com/ai-training-plan/';
      default:
        return '';
    }
  }
}
