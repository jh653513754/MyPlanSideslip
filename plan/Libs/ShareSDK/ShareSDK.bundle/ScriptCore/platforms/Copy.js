var $pluginID = "com.mob.sharesdk.Copy";eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([2-9a-zA-Z]|1\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('b B={"C":"covert_url"};8 a(9){7.V=9;7.i={"w":5,"x":5}}a.c.9=8(){g 7.V};a.c.t=8(){g"拷贝"};a.c.cacheDomain=8(){g"SSDK-Platform-"+$2.3.W.a};a.c.M=8(){6(7.i["x"]!=5&&7.i["x"][B.C]!=5){g 7.i["x"][B.C]}l 6(7.i["w"]!=5&&7.i["w"][B.C]!=5){g 7.i["w"][B.C]}g $2.3.M()};a.c.localAppInfo=8(G){6(X.N==0){g 7.i["w"]}l{7.i["w"]=G}};a.c.serverAppInfo=8(G){6(X.N==0){g 7.i["x"]}l{7.i["x"]=G}};a.c.saveConfig=8(){};a.c.isSupportAuth=8(){g false};a.c.authorize=8(H,settings){b f={"m":$2.3.u.D,"n":"平台［"+7.t()+"］不支持授权功能!"};$2.native.ssdk_authStateChanged(H,$2.3.o.q,f)};a.c.cancelAuthorize=8(4){};a.c.getUserInfo=8(query,4){b f={"m":$2.3.u.D,"n":"平台［"+7.t()+"］不支持获取用户信息功能!"};6(4!=5){4($2.3.o.q,f)}};a.c.addFriend=8(H,user,4){b f={"m":$2.3.u.D,"n":"平台["+7.t()+"]不支持添加好友方法!"};6(4!=5){4($2.3.o.q,f)}};a.c.getFriends=8(cursor,size,4){b f={"m":$2.3.u.D,"n":"平台["+7.t()+"]不支持获取好友列表方法!"};6(4!=5){4($2.3.o.q,f)}};a.c.share=8(H,j,4){b r=5;b y=5;b d=5;b e=5;b p=7;b I=j!=5?j["@I"]:5;b J={"@I":I};b 9=$2.3.z(7.9(),j,"9");6(9==5){9=$2.3.k.Y}6(9==$2.3.k.Y){9=7.Z(j)}6(9!=$2.3.k.O&&9!=$2.3.k.P&&9!=$2.3.k.Q){b f={"m":$2.3.u.UnsupportContentType,"n":"不支持的分享类型["+9+"]"};6(4!=5){4($2.3.o.q,f,5,J)}g}$2.R.isPluginRegisted("com.2.sharesdk.connector.copy",8(h){6(h.A){10(9){E $2.3.k.O:r=$2.3.z(p.9(),j,"r");F;E $2.3.k.P:y=$2.3.z(p.9(),j,"d");6(11.c.12.13(y)===\'[14 15]\'){d=y}F;E $2.3.k.Q:e=$2.3.z(p.9(),j,"e");F}p.16([r,e],8(h){r=h.A[0];e=h.A[1];p.K(d,0,8(d){$2.R.ssdk_copy(9,r,d,e,8(h){b L=h.L;b v=5;10(L){E $2.3.o.Success:{v={};v["r"]=r;6(y!=5){v["d"]=y}6(e!=5){v["S"]=[e]}F}E $2.3.o.q:v={"m":h["m"],"n":h["n"]};F}6(4){4(L,v,5,J)}})})})}l{b f={"m":$2.3.u.APIRequestFail,"n":"平台["+p.t()+"]需要依靠17.18进行分享，请先导入17.18后再试!"};6(4!=5){4($2.3.o.q,f,5,J)}}})};a.c.callApi=8(e,method,params,4){b f={"m":$2.3.u.D,"n":"平台［"+7.t()+"］不支持获取用户信息功能!"};6(4!=5){4($2.3.o.q,f)}};a.c.createUserByRawData=8(rawData){g 5};a.c.Z=8(j){b 9=$2.3.k.O;b d=$2.3.z(7.9(),j,"d");6(11.c.12.13(d)===\'[14 15]\'){9=$2.3.k.P}b S=$2.3.z(7.9(),j,"e");6(S!=5){9=$2.3.k.Q}g 9};a.c.K=8(d,s,4){6(d==5){6(4!=5){4(d)}g}b p=7;6(s<d.N){b T=d[s];6(T!=5){7.19(T,8(e){d[s]=e;s++;p.K(d,s,4)})}l{s++;7.K(d,s,4)}}l{6(4!=5){4(d)}}};a.c.19=8(e,4){6(!/^(file\\:\\/)?\\//.test(e)){$2.R.downloadFile(e,8(h){6(h.A!=5){6(4!=5){4(h.A)}}l{6(4!=5){4(5)}}})}l{6(4!=5){4(e)}}};a.c.16=8(U,4){6(7.M()){$2.3.convertUrl(7.9(),5,U,4)}l{6(4){4({"A":U})}}};$2.3.registerPlatformClass($2.3.W.a,a);',[],72,'||mob|shareSDK|callback|null|if|this|function|type|Copy|var|prototype|images|url|error|return|data|_appInfo|parameters|contentType|else|error_code|error_message|responseState|self|Fail|text|index|name|errorCode|resultData|local|server|origImgs|getShareParam|result|CopyInfoKeys|ConvertUrl|UnsupportFeature|case|break|value|sessionId|flags|userData|_dealImages|state|convertUrlEnabled|length|Text|Image|WebPage|ext|urls|imageUrl|contents|_type|platformType|arguments|Auto|_getShareType|switch|Object|toString|apply|object|Array|_convertUrl|ShareSDKConnector|framework|_getImagePath'.split('|'),0,{}))