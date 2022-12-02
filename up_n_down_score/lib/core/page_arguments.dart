enum PageActonType {
  create,
  edit,
  delete,
  update,
  view,
  save,
  cancel,
}

class PageArguments {
  PageActonType? action;
  int? id;
  String? backRouteName;

  PageArguments({
    this.action,
    this.id,
    this.backRouteName,
  });
}
