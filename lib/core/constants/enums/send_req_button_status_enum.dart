enum SendRequestButtonStatus {
  save, // If I have opened other user's profile from "nearby"
  saved, // If I have added other user in nearby and waiting for timeout
  connect, // If I have opened other user's profile from "feeds, city"
  requestSent, // If I have sent a request and waiting for him/her to accept
  accept, // If other user sent me a connection request and waiting for me to accept
  connected, // If we are friends!
  blocked, // If you blocked
}