jQuery ->

# Initializing the FB SDK with the correct app
`
window.fbAsyncInit = function() {
  FB.init({appId: fb_app_id, status: true, xfbml: true});
};

// Load the SDK asynchronously
(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/en_US/all.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));
`

window.postToFeed = ->

  #calling the API ...
  obj =
    method: "feed"
    link: Share.link
    picture: Share.picture
    name: Share.name
    caption: Share.brand_name
    description: Share.description
    display: "iframe"

  callback = (response) ->
    if(response)
      $.jGrowl("Hall shared successfully to Facebook")

  FB.ui obj, callback
