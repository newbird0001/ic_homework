import List "mo:base/List";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import DateTime"mo:datetime/DateTime";
import Text"mo:base/Text";

actor {

  type Message = Text;

  type microblog=actor {
    name_posts:shared(targetname:Text)->async [Text];
    get_followsname:shared()->async [Text];//关注者名单
    set_name:shared(name:Text)->();//设置作者昵称
    get_name:shared()->async Text;//获取作者昵称
    post:shared(message:Message)->async();//发布自己的博客
    posts:shared query()->async [Message];//显示自己已经发布的博客
    follows:shared query()->async [Text];//显示自己的关注者
    follow:shared(id:Principal)->async();//关注某位博主
    timeline:shared ()->async [Message];//显示已关注博主的博文
    };

  var messages = List.nil<Message>();
  var followed = List.nil<Text>();
  stable var a_name:Text = "";
  public shared(mes) func post(otp:Text,message:Text):async()
  {
    assert( otp == "123321");

    let post_time_UTC8 = DateTime.toTextAdvanced(DateTime.fromTime(Time.now() + 8*3600*1_000_000_000), #custom({format="YYYY-MM-DD HH:mm:ss";locale=null}));
    
    if (a_name == "")
    {
        let temp:Message =""# message #"
        发布时间:("# post_time_UTC8 #")
        作者:匿名";
        messages := List.push(temp,messages);
    }
    else
    {
        let temp:Message =""# message #"
        发布时间:("# post_time_UTC8 #")
        作者:"# a_name #"";
        messages := List.push(temp,messages);
    };
    
    
  };

  public shared(mes) func follow(id:Principal):async()
  {
    

    followed := List.push(Principal.toText(id),followed);
  };

  public shared query func follows():async [Text]
  {
    return List.toArray(followed);    
  };

   public shared query func posts():async [Message]
  {
    return List.toArray(messages);    
  };

  public shared  func timeline():async [Message]
  {
    var all = List.nil<Message>();
    for(id in Iter.fromList(followed))
    {
      let canister:microblog=actor(id);
      let mes=await canister.posts();
      for(m in Iter.fromArray(mes))
      {
        all:=List.push(m,all);
      }
    };
    return List.toArray(all);
  };

  public shared func set_name(name:Text):(){
      a_name:=name;
  };

  public shared func get_name():async Text{
      if (a_name == "") {"匿名"}
      else{a_name};
  };

   public shared func get_followsname():async [Text]{
        var all_name = List.nil<Text>();
        for(id in Iter.fromList(followed))
        {
            let canister:microblog=actor(id);
            let aname=await canister.get_name();
            all_name:=List.push(aname,all_name);
        };
        return List.toArray(all_name);
    };

    public shared func name_posts(targetname:Text):async [Text]{
        for(id in Iter.fromList(followed))
        {
            let canister:microblog=actor(id);
            let aname=await canister.get_name();
            if(aname == targetname)
            {
                return await canister.posts();
            }
            
        };
        return [];
            
    };

};

