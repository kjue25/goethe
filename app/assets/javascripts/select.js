window.onload = function() {

  //Scrolls to the first panel when Begin button is clicked
  $('body').click(function(e){  
    if (e.target.id == 'go') {
      $('html,body').animate({scrollTop:$("#site_panels").offset().top}, 1000);
    }
  });

  $('.single-select').on("click", function(e) {
    var selected;
    var service_blocks = $(".service-block");
    var children = e.target.childNodes;

    if (children.length == 7) {
      var lastSelected = document.getElementById("selected");
      console.log("Selecting single" + lastSelected);
      if (e.target.id == "selected") {
        console.log("De-selecting");
        var index = selected_tags.indexOf(lastSelected.children[1].innerHTML);
        lastSelected.id = "";
        if (index > -1) {
          selected_tags.splice(index, 1);
        }
        $('.service-block').css("background-color", "#D3D3D3");
        display_panels();
      } else {
        if (lastSelected) {
          var index = selected_tags.indexOf(lastSelected.children[1].innerHTML);
          lastSelected.id = "";
          if (index > -1) {
            selected_tags.splice(index, 1);
          }
        }

        var tag = children[3];
        selected = tag.innerHTML;
        selected_tags.push(selected);
        console.log("Updated single" + selected_tags);

        $('.service-block').css("background-color", "#D3D3D3");
        e.target.style.background = "#000000";
        e.target.id = "selected";

        display_panels();
      }
    }
  });

  $('.multi-select').on("click", function(e) {
    if (!e.target.firstChild) {
      var container = e.target.parentNode.parentNode;
      var selected = container.children[1].children[0].innerHTML;

      if (e.target.style.background == "red") {
        var index = selected_tags.indexOf(selected);
        console.log("Deselecting" + index);
        if (index > -1) {
          console.log("Deselecting" + index);
          selected_tags.splice(index, 1);
        }
        console.log("One less multi" + selected_tags);
        e.target.style.background = "#e84c3d"; //Fix this color
      } else {
        selected_tags.push(selected);
        console.log("Selecting multi" + selected_tags);
        e.target.style.background = "red";
      }
      display_panels();
    }
  });
};

$(document).ready(function() {
  selected_tags = [];
});

function display_panels() {
  var select_request = new XMLHttpRequest();
  var page_id = $(".page_id")[0].id;
  var URL = "/sites/select?selected=" + selected_tags + "&id=" + page_id;
  select_request.open("GET", URL, true);
  select_request.send();
  select_request.onreadystatechange = function() {
    if (this.readyState==4 && this.status==200) {
      var panels = JSON.parse(this.responseText);
      var first_displayed;
      var counter = 0;
      for (i=0; i < panels.length; i++) {
        if(panels[i][1] == 1) {
          ($(document.getElementById("panel_" + panels[i][0].id))).show();
          //Code to keep track of what panel should be scrolled to after option is selected
          //if (counter == 1) {
          //  first_displayed = panels[i][0].id;
          //}
          //counter++;
        } else { //panel should be hidden
          ($(document.getElementById("panel_" + panels[i][0].id))).hide();
          //If this is a single-select/multi-select panel, remove tags from selected_tags
          if ((panels[i][2] == "SSelectpanel") || (panels[i][2] == "MSelectpanel")) {
            tags = panels[i][3];
            for (j=0; j<tags.length; j++) {
              var index = selected_tags.indexOf(tags[j].option_title);
              if (index > -1) {
                $(".fa-"+tags[j].id).css("background", "#e84c3d"); //Fix this color
                selected_tags.splice(index, 1);
                display_panels();
              }
            }
          }
        }
      }
      //Scroll to the first newly displayed panel
      //console.log(first_displayed);
      //$('html,body').animate({scrollTop:$("#panel_" + first_displayed).offset().top}, 1000); //Scroll to the first newly displayed panel
    }
  }
};
