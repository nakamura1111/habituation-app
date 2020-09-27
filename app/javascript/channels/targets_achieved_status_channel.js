import consumer from "./consumer"

consumer.subscriptions.create("TargetsAchievedStatusChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    // レベルを反映する
    const targetLevel = document.getElementById("target-level");
    console.log(data.content);
    console.log(targetLevel.innerHTML);
    if ( targetLevel.innerHTML != `Lv. ${data.content.level}` ) {
      targetLevel.innerHTML = `Lv. ${data.content.level} - Level up!`;
      targetLevel.style.color = 'red';
      targetLevel.style.fontSize = '40px';
    }
    // 経験値を反映する
    const expBar = document.getElementById("exp-bar");
    console.log(expBar);
    expBar.setAttribute('value', data.content.exp);
  }
});
