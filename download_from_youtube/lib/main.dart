import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:youtube_extractor/youtube_extractor.dart';


// first executes
void main() {

  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    )
  );

  // change the status bar color and navigation bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark
  ));

}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  bool _isProcessed;

  String _videoDownloadUrl;
  String _audioDownloadUrl;

  var extractor = YouTubeExtractor();


  TextEditingController _txtYoutubeUrlController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Center(
          child: Column(

            children: <Widget>[


              Image(
                image: AssetImage("assets/youtube.png"),
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Youtube URL",
                    labelText: "YouTube URL",
                  ),

                  controller: _txtYoutubeUrlController,

                ),
              ),

              SizedBox(
                height: 20,
              ),

              OutlineButton(
                child: Text("Process"),
                onPressed: _getDownloadLink,
              ),


              SizedBox(
                height: 40,
              ),

              _isProcessed==true?Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    RaisedButton(
                      child: Text("Video"),
                      onPressed: () {
                        _launchURL(context, _videoDownloadUrl);
                      },
                      color: Colors.redAccent,
                      textColor: Colors.white,
                    ),

                    SizedBox(width: 20,),

                    RaisedButton(
                      child: Text("Audio"),
                      onPressed: () {
                        _launchURL(context, _audioDownloadUrl);
                      },
                    ),

                  ],
                ),

              ):Container(),


            ],

          ),
        ),
      ),


    );
  }


  // get downloadable link
  void _getDownloadLink() async {

    String youtubeURL = _txtYoutubeUrlController.text;


    if(youtubeURL.isNotEmpty) {

      // get the video id

      youtubeURL = youtubeURL.replaceAll("https://www.youtube.com/watch?v=", "");
      youtubeURL = youtubeURL.replaceAll("https://youtu.be/", "");

      // after replace we get the id

      var audioUrlInfo = await extractor.getMediaStreamsAsync(youtubeURL);

      _audioDownloadUrl = audioUrlInfo.audio.first.url;

      var videoUrlInfo = await extractor.getMediaStreamsAsync(youtubeURL);

      _videoDownloadUrl = videoUrlInfo.video.first.url;


      setState(() {
        _isProcessed = true;
      });


    }


  }


  // open the url
  void _launchURL(BuildContext context, String url) async {

    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn()
        ),
      );
    } catch (e) {
      print(e.toString());
    }

  }


}
