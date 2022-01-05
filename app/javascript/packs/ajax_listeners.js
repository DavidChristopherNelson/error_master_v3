document.body.addEventListener("ajax:success", (event) => {
  const [data, status, xhr] = event.detail;

  // Place data into the main content.
  if (data.main_content !== null) {
    var main_content_tag = document.querySelector(".main-content");
    main_content_tag.innerHTML = "";
    main_content_tag.insertAdjacentHTML('afterbegin', data.main_content);
  }

  // Place data into the tool bar.
  if (data.tool_bar !== null) {
    var tool_bar_tag = document.querySelector(".tool-bar");
    tool_bar_tag.innerHTML = "";
    tool_bar_tag.insertAdjacentHTML('afterbegin', data.tool_bar);
  }

  // Update the error counts in the side bar.
  var folders = document.querySelectorAll(".folder");
  folders.forEach(function(folder) {
    var num_of_errors = data.side_bar_update_counts[folder.id]["num_of_errors"];
    folder_link = folder.querySelector(".error_count");
    folder_link.innerHTML = "";
    // The if/else statement correctly pluralises the word 'error'.
    if (num_of_errors === "1") {
      folder_link.insertAdjacentHTML('afterbegin', `${num_of_errors} error`);
    } else {
      folder_link.insertAdjacentHTML('afterbegin', `${num_of_errors} errors`);
    }
  });

  var check_all_button = document.querySelector(".check-all");
  if (check_all_button !== null) {
    check_all_button.addEventListener("click", (event) => {
      document.querySelectorAll('input[type=checkbox]').forEach(function(folder) {
        folder.click();
      });
    });
  }
});
