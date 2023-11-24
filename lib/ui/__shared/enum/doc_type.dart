enum DocType { add, view, edit }

DocType getDocType<T>(T? value, bool enableEdit) {
  if (value != null && enableEdit) {
    return DocType.edit;
  } else if (value != null) {
    return DocType.view;
  }
  return DocType.add;
}
