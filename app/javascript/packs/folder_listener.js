alert("line 1 folder_listener.js");
document.querySelector(".check-all").addEventListener("click", (event) => {
  alert("line 3 folder_listener.js");
  document.querySelectorAll('input[type=checkbox]').forEach(function(folder) {
    folder.click();
  });
});
