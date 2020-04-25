import API from "../util/API";

/**
 * Controller for the SignUpPage
 */
export default class ActivationController {

  /**
   *  Sends a post request to server
   */
  async activateUser(token: string): Promise<any> {
    var postData = {
      token: token
    };
    let result = await API.post("/api/user/activate", postData)
      .then(function(response: any) {
        if (response.status === 200) {
          return true;
        }
      })
      .catch(function(error: any) {
        if (error.response.status === 500 ) {
          return { error: "Error connecting to the server" };
        } else {
          return { error: "Invalid token" };
        }
      });
    return result;
  }
}
