import API from "../util/API";

/**
 * Controller for the LoginPage
 */
export default class LoginController {

  /**
   *  Gets user from database if username/email and password are correct. Returns error message otherwise
   */
  async login(user: string, pass: string): Promise<any> {
    var data = {
      "user": user,
      "password": pass
    };
    let userData = await API.post("/api/user/login", data)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
      })
      .catch(function(error: any) {
        if (error.response.status === 404) {
          return {error: "Email/username not found"};
        }else if (error.response.status === 401) {
          return {error: "Password incorrect"};
        }else{
          return {error: "Error connecting to the server"};
        }
      });
    return userData;
  }
}
