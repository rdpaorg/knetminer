<%
// added to overcome double quotes issue in API search
String keywords="";
if(request.getParameter("keyword")!=null) {
keywords = request.getParameter("keyword");
keywords = keywords.replace("\"", "###");
}
// added to display genepage API - query summary above rendered network
String genelist="";
if(request.getParameter("list")!=null) {
genelist = request.getParameter("list");
}
String datasetDescription= "Discover the KnetMiner knowledge network for gene(s): <span style='color:darkOrange'>"+ genelist + "</span> (blue triangles with yellow label) and potential links ";
if(request.getParameter("keyword")!=null) {
datasetDescription= datasetDescription + "to <span style='color:darkOrange'>" + keywords + "</span> related nodes. If the genes do not have a link to <span style='color:darkOrange'>"+ keywords +"</span>, you will see links to any phenotype/trait (<i>green rectangles and pentagons</i>). ";
}
else {
// when no keyword is provided
datasetDescription= datasetDescription + "to <b>any</b> phenotype/trait (green rectangles and pentagons). ";
}
datasetDescription= datasetDescription + "<i><u>Tip:</u> Right-click-hold on nodes to add labels or to show their properties. Use the Interactive Legend to add (single-click) or hide (double-click) other types of information to/from the network.</i>";
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="https://knetminer.rothamsted.ac.uk/KnetMaps/css_demo/index-style.css">
<link rel="stylesheet" type="text/css" href="https://knetminer.rothamsted.ac.uk/KnetMaps/dist/css/knetmaps.css"/>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
<!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/StephanWagner/jBox@v1.0.6/dist/jBox.all.min.css"> -->
<link rel="stylesheet" type="text/css" href="css/jBox.all.min.css">
<link rel="stylesheet" type="text/css" href="css/loginStyle.css">

<!-- <script src="https://cdn.jsdelivr.net/gh/StephanWagner/jBox@v1.0.6/dist/jBox.all.min.js"></script> -->
<script type="text/javascript" src="js/jBox.all.min.js"></script>
<script type="text/javascript" src="js/loginHandler/cookieUtils.js"></script>
<script type="text/javascript" src="js/loginHandler/loginUtils.js"></script>
<script type="text/javascript" src="js/saveKnetwork/save-knet.js"></script>
<script type="text/javascript" src="https://knetminer.rothamsted.ac.uk/KnetMaps/dist/js/knetmaps-lib.min.js"></script>
<script type="text/javascript" src="https://knetminer.rothamsted.ac.uk/KnetMaps/dist/js/knetmaps.min.js"></script>
<title>KnetMiner network</title>
</head>
<body>
   <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
	   <a target="_blank" href="https://knetminer.org"><img class="logo-top" src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/logo-regular.png" height="48" alt="Logo"></a>   
       <ul class="nav navbar-nav" id="top">
          <li>
              <a target="_blank" href="https://pub.uni-bielefeld.de/publication/2915227">Cite Us</a>
              <a target="_blank" href="http://knetminer.rothamsted.ac.uk/KnetMiner/KnetMiner_Tutorial-v3.1.pdf">User Guide</a>
              <a target="_blank" href="https://github.com/Rothamsted/KnetMiner/issues">Report Issues</a>
              <a id="login_icon" title="Sign in" style="text-decoration:none; float:right;">Sign in</a>
              <a id="profile_icon" title="Profile" style="float:right; color:orange;">
                  <svg class="svg-inline--fa fa-user fa-w-14" aria-hidden="true" data-prefix="fa" data-icon="user" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg=""><path fill="currentColor" d="M224 256c70.7 0 128-57.3 128-128S294.7 0 224 0 96 57.3 96 128s57.3 128 128 128zm89.6 32h-16.7c-22.2 10.2-46.9 16-72.9 16s-50.6-5.8-72.9-16h-16.7C60.2 288 0 348.2 0 422.4V464c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48v-41.6c0-74.2-60.2-134.4-134.4-134.4z"></path></svg><!-- <i class="fa fa-user" aria-hidden="true"></i> -->
              </a>
          </li>
    </ul>
 	</nav>  <!-- end navbar -->

<div id="content">
    <div id="dataset-description"><p id="dataset-desc"><%=datasetDescription%></p></div><br/>
    <div id="NetworkCanvas">
        <div id="knetSaveButton" style="width:101%; margin-top:7px;"></div>
        <!-- KnetMaps -->
        <div id="knetmap"></div>
    </div>
</div>  <!-- content -->

       <div class="contact-footer">
	      <ul style="overflow:hidden;margin-bottom: 0px;">
		     <li class="left-footer">
			   <a target="_blank" title="Rothamsted Research" href="http://www.rothamsted.ac.uk/" class="logos"><img src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/rothamsted_logo.png" width="80" height="80"/></a>
			   <a target="_blank" title="BBSRC" href="http://www.bbsrc.ac.uk/" class="logos"><img class="bbsrc-logo" src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/bbsrc_logo.png"/></a>
			 </li>
		     <li class="center-footer">
			   <a target="_blank" title="KnetMiner" href="https://knetminer.org" class="logos"><img src="https://knetminer.rothamsted.ac.uk/KnetMaps/image/logo-regular.png" height="90"/></a>
			 </li>
			 <li class="right-footer">
			   <ul class="nav navbar-nav" id="bottom">
			     <li>
				   <p id="footer-text">Powered by <a target="_blank" href="https://f1000research.com/articles/7-1651/v1" style="color:darkOrange">KnetMaps.js</a></p>
				   <a target="_blank" href="https://www.npmjs.com/package/knetmaps">NPM</a>
				   <a target="_blank" href="https://github.com/Rothamsted/knetmaps.js/blob/master/LICENSE">License</a>
				   <a target="_blank" href="https://twitter.com/knetminer">Twitter</a>
				 </li>
			   </ul>
			 </li>
		  </ul>
       </div>

	<script type="text/javascript">
		$.ajax({
            url: "network",
            type: "post",
            headers: {
                "Accept": "application/json; charset=utf-8",
                "Content-Type": "application/json; charset=utf-8"
            },
            dataType: "json",
            data: JSON.stringify({
                keyword: "<%=keywords%>",
                list: ${list}
            })
        }).success(function (data) {
            // new Save button in Network View - intialise a click-to-save button with networkId (null when inside knetminer)
            var networkId= null;
            $('#knetSaveButton').html("<button id='saveJSON' class='btn knet_button' style='float:right;' onclick='exportAsJson("+networkId+");' title='Save the knetwork to knetspace'>Save</button>");
                                        
            if(data.graph.includes("var graphJSON=")) { // for old/current json that contains 2 JS vars
               KNETMAPS.KnetMaps().drawRaw('#knetmap', data.graph/*, networkId*/);
              }
            else { // response contents (pure JSON).
                var eles_jsons= data.graph.graphJSON.elements;
                var eles_styles= data.graph.graphJSON.style;
                var metadata_json= data.graph.allGraphData;
                KNETMAPS.KnetMaps().draw('#knetmap', eles_jsons, metadata_json, eles_styles/*, networkId*/);
               }
        });
		</script>
</body>
</html>
