
$.rails.allowAction = function(link) {
  if (!link.attr('data-confirm')) {
   return true;
  }
  showConfirm.init(link);
  // $.rails.showConfirmDialog(link);
  return false;
};

$.rails.confirmed = function(link) {
  link.removeAttr('data-confirm');
  return link.trigger('click.rails');
};

$.rails.showConfirmDialog = function(link) {
  var html, message;
  message = link.attr('data-confirm');
  html = "<div class=\"modal\" id=\"confirmationDialog\">\n  <div class=\"modal-header\">\n    <a class=\"close\" data-dismiss=\"modal\">Ã</a>\n    <h3>Are you sure Mr. President?</h3>\n  </div>\n  <div class=\"modal-body\">\n    <p>" + message + "</p>\n  </div>\n  <div class=\"modal-footer\">\n    <a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n    <a data-dismiss=\"modal\" class=\"btn btn-primary confirm\">OK</a>\n  </div>\n</div>";
  $(html).modal();
  return $('#confirmationDialog .confirm').on('click', function() {
    return $.rails.confirmed(link);
  });
};

var showConfirm = {
  init:function(link){
    var html, message;
    message = link.attr('data-confirm');
    //html = "<div class=\"modal\" id=\"confirmationDialog\">\n<div class=\"modal-content\"><div class=\"modal-header\">\n    <a class=\"close\" data-dismiss=\"modal\">Ã</a>\n    <h3>Are you sure Mr. President?</h3>\n  </div>\n  <div class=\"modal-body\">\n    <p>" + message + "</p>\n  </div>\n  <div class=\"modal-footer\">\n    <a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n    <a data-dismiss=\"modal\" class=\"btn btn-primary confirm\">OK</a>\n  </div></div>\n</div>";

    $("#confirmationDialog").modal('show');
    return $('#confirmationDialog .confirm').on('click', function() {
      return $.rails.confirmed(link);
    });
  }
}