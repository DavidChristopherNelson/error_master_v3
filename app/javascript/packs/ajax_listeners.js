document.body.addEventListener("ajax:success", (event) => {
  const [data, status, xhr] = event.detail;

  // Place data into the main content.
  var main_content_tag = document.querySelector(".main-content");
  main_content_tag.innerHTML = "";
  main_content_tag.insertAdjacentHTML('afterbegin', data.main_content);

  // Place data into the top bar.
  var tool_bar_tag = document.querySelector(".tool-bar");
  tool_bar_tag.innerHTML = "";
  tool_bar_tag.insertAdjacentHTML('afterbegin', data.tool_bar);
});