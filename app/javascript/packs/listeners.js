/*
window.addEventListener("load", (event) => {
  alert("page load detected");
  modal_listeners();
});

document.body.addEventListener("ajax:success", (event) => {
  alert("ajax success detected");
  ajax_listeners();
  bulk_action_listeners();
  modal_listeners();
});

function ajax_listeners() {
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
  if (data.side_bar_update_counts in window === false) {
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
  }

  // Update the data in the dropdown menu.
  var filters = document.querySelectorAll(".filter");
  if (data.dropdown !== null) {
    filters.forEach(function(filter) {
      anchor_tag = filter.querySelector("a");
      anchor_tag.innerHTML = "";
      anchor_tag.insertAdjacentHTML('afterbegin', `${data.dropdown[filter.id]["execution_order"]}: ${data.dropdown[filter.id]["name"]}`);
    })
  }
}

function modal_listeners() {
  // Show modal.
  var modal_triggers = document.querySelectorAll(".modal-trigger");
  if (modal_triggers !== null) {
    modal_triggers.forEach(function(modal_trigger) {
      modal_trigger.addEventListener("click", function() {
        var modal = document.querySelector(`${this.dataset.target}`);
        modal.style.display = "flex";
      });
    });
  }

  // Close modal.
  var close_modal = document.querySelectorAll(".close-modal");
  var modals = document.querySelectorAll(".modal");
  if (close_modal !== null) {
    close_modal.forEach(function(close) {
      close.addEventListener("click", function() {
        modals.forEach(function(modal) {
          modal.style.display = "none";
        });
      });
    });
  }
}

function bulk_action_listeners() {
  // The check all button for the bulk action form in the show folder view. 
  var check_all_button = document.querySelector(".check-all");
  if (check_all_button !== null) {
    check_all_button.addEventListener("click", (event) => {
      document.querySelectorAll('input[class=error-checkbox]').forEach(function(checkbox) {
        checkbox.click();
      });
    });
  }

  // This submits the bulk action form when the read/unread checkbox is clicked.
  var read_submit_button = document.querySelector("#mark-as-read-button");
  if (read_submit_button !== null) {
    read_submit_button.addEventListener("click", (event) => {
      document.querySelector('input[id=mark_as_read]').click();
    });
  }
  var unread_submit_button = document.querySelector("#mark-as-unread-button");
  if (unread_submit_button !== null) {
    unread_submit_button.addEventListener("click", (event) => {
      document.querySelector('input[id=mark_as_unread]').click();
    });
  }
}
*/
