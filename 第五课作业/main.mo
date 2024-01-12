type Message = {
      content:Text;
      post_time:Text;
      name:Text;
  };
stable var a_name:Text = "";

public shared func set_name(name:Text):(){
      a_name:=name;
  };

public shared func get_name():async ?Text{
      if (a_name == "") {null}
      else{?a_name};
  };
