import List "mo:base/List";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import DateTime"mo:datetime/DateTime";
import Text"mo:base/Text";

actor {

  type Message = {
      content:Text;
      post_time:Text;
  };

  type microblog=actor {
    post:shared(message:Message)->async();//发布自己的博客
    posts:shared query(since:Time.Time)->async [Message];//显示自己发布的所有博文。时间段:N天之前到现在
    follows:shared query()->async [Text];//显示自己的关注者
    follow:shared(id:Principal)->async();//关注某位博主
    timeline:shared (since:Time.Time)->async [Message];//显示已关注博主的博文。时间段:N天之前到现在
    };

  var messages = List.nil<Message>();
  var followed = List.nil<Text>();

  public shared(mes) func post(message:Text):async()
  {
    assert(Principal.toText(mes.caller) == "ov7vd-ed44i-szzhq-2gyik-6kb7y-wvckb-vtkc6-enrd4-i6nlz-ppmpj-pae");

    let post_time_UTC8 = DateTime.toTextAdvanced(DateTime.fromTime(Time.now() + 8*3600*1_000_000_000), #custom({format="YYYY-MM-DD HH:mm:ss";locale=null}));

    let temp:Message ={content=message;post_time=post_time_UTC8};

    messages := List.push(temp,messages);
  };

  public shared(mes) func follow(id:Principal):async()
  {
    assert(Principal.toText(mes.caller) == "ov7vd-ed44i-szzhq-2gyik-6kb7y-wvckb-vtkc6-enrd4-i6nlz-ppmpj-pae");

    followed := List.push(Principal.toText(id),followed);
  };

  public shared query func follows():async [Text]
  {
    return List.toArray(followed);    
  };

   public shared query func posts(since:Time.Time):async [Message]
  {
    var temp_blog=List.nil<Message>();
    
    let time_begin = DateTime.toTextAdvanced(DateTime.fromTime(8*3600*1_000_000_000 + Time.now() - since*24*3600*1_000_000_000), #custom({format="YYYY-MM-DD HH:mm:ss";locale=null}));

    let iter = Iter.fromList(messages);
    let mappedIter = Iter.filter(iter, func (x : Message) : Bool { Text.greaterOrEqual(x.post_time,time_begin) });

    for(blog in mappedIter){
        temp_blog:=List.push(blog, temp_blog);
    };


    return List.toArray(temp_blog);    
  };

  public shared  func timeline(since:Time.Time):async [Message]
  {
    var all = List.nil<Message>();
    for(id in Iter.fromList(followed))
    {
      let canister:microblog=actor(id);
      let mes=await canister.posts(since);
      for(m in Iter.fromArray(mes))
      {
        all:=List.push(m,all);
      }
    };
    return List.toArray(all);
  };

};
