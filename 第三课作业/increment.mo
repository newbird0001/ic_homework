import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
actor {
  stable var count:Nat=0;
  public func set(num:Nat):()
  {
    count :=num;
  };
  
  public func add() : async () {
    count:=count + 1;
  };

  public query func search() : async Nat {
    count;
  };

  type HttpRequest = {
    body:Blob;
    headers:[HeaderField];
    method:Text;
    url:Text;
  };

   type HttpResponse = {
    body:Blob;
    headers:[HeaderField];
    status_code:Nat16;
  };

  type HeaderField = (Text,Text);

  public query func http_request(args: HttpRequest):async HttpResponse
  {
    let content = "<html><body><h1> the value is "# Nat.toText(count) #".</h1></body></html>";
    {
      body=Text.encodeUtf8(content);
      headers = [("Content-Type", "text/html")];
      status_code = 200;

    };
  };
  
};
