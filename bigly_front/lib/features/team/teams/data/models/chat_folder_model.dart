
class ChatFolderModel {
  ChatFolder? chatFolder;

  ChatFolderModel({this.chatFolder});


  ChatFolderModel.fromJson(String json) {
    switch (json) {
      case "All":
        chatFolder = ChatFolder.all;
        break;
      case "Unread":
        chatFolder = ChatFolder.unread;
        break;
      case "Superhero":
        chatFolder = ChatFolder.superHero;
        break;
      case "Subscriber":
        chatFolder = ChatFolder.subscriber;
        break;
      case "Follower":
        chatFolder = ChatFolder.follower;
        break;
      case "Group":
        chatFolder = ChatFolder.group;
        break;
      case "Pinned":
        chatFolder = ChatFolder.pinned;
    }
  }
}

enum ChatFolder {
  all,
  unread,
  superHero,
  subscriber,
  follower,
  group,
  pinned
}
