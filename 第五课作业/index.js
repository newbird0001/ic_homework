import { hello_backend } from "../../declarations/hello_backend";

async function post(){
    let post_button=document.getElementById("post");
    post_button.disabled=true;
    let textarea=document.getElementById("message");
    let text = textarea.value;
    let textarea_otp=document.getElementById("otp");
    let text_otp = textarea_otp.value;
    let err_text =document.getElementById("err");
    err_text.innerText="";
    try{
        await hello_backend.post(text_otp,text);
    }
    catch(err)
    {
        console.log(err);
        err_text.innerText="password wrong!";

    }
    post_button.disabled=false;
}

async function find(){
   
    let textarea=document.getElementById("follows");
    let index = textarea.selectedIndex
    let text = textarea.options[index].value;
    let posts = await hello_backend.name_posts(text);
    let posts_section=document.getElementById("followspost");

    posts_section.replaceChildren([]);
    for(var i=0;i<posts.length;i++)
    {
        let post = document.createElement('p');
        post.innerText=posts[i];
        posts_section.appendChild(post);
    }
}

async function set()
{
    let set_button=document.getElementById("setname");
    set_button.disabled=true;
    let name_in=document.getElementById("name");
    let text = name_in.value;
    name_in.disabled=true;
    await hello_backend.set_name(text);
    
}

var posts_num=0;

async function load_posts(){
    let posts_section=document.getElementById("posts");
    let posts = await hello_backend.timeline();
    if(posts_num == posts.length) return;
    posts_num = posts.length;
    posts_section.replaceChildren([]);
    for(var i=0;i<posts.length;i++)
    {
        let post = document.createElement('p');
        post.innerText=posts[i];
        posts_section.appendChild(post);
    }

}

async function set_list(){
    let select = document.getElementById("follows");
    let name_list= await hello_backend.get_followsname();
    for(var i=0;i<name_list.length;i++)
    {
        let name=document.createElement("option");
        name.textContent=name_list[i];
        name.value=name_list[i];
        select.appendChild(name);

    }
}

async function on_load(){
    let post_button=document.getElementById("post");
    post_button.onclick=post;
    let set_button=document.getElementById("setname");
    set_button.onclick=set;
    let find_button=document.getElementById("find");
    find_button.onclick=find;
    set_list();
    load_posts();
    setInterval(load_posts,3000);
}

window.on_load=on_load();
