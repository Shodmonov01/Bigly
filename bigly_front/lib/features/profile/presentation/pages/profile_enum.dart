
enum ProfileEnum {
  discover,
  subscribe,
  myProfile,
  myContentPlan,
}

extension ProfileEnumExtension on ProfileEnum {
  bool get isDiscover => ProfileEnum.discover == this;
  bool get isSubscribe => ProfileEnum.subscribe == this;
  bool get isMyProfile => ProfileEnum.myProfile == this;
  bool get isMyContentPlan => ProfileEnum.myContentPlan == this;
}
