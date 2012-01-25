$(function(){

  get_sympathies();

  $(".sympathy_button").click(function(){
    var _this = $(this);
    var id = _this.attr("id");

    $.ajax({ type: "POST", url: "me_too", data: "id="+id,
      success: function(msg) {
        get_sympathies();
      }, error: function(e) {
      }
    });

  });


  function get_sympathies() {
    $.getJSON("sympathies.json", function(json){
      $.each(json, function() {
        var _this = this;
        $("#id-" + _this.id + " .sympathy_button").text("ぼくもきらい / "+ _this.count +" 人");
      });
    });
  }

});
