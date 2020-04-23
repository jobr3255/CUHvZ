import API from "../util/API";
import LoginController from "./LoginController";

/**
 * Controller for the SignUpPage
 */
export default class SignUpController extends LoginController {

  /**
   *  Gets usernames and emails from the database
   */
  async getUsersList(): Promise<any[]> {
    let userData = await API.get("/api/users")
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return null;
      })
      .catch(function(error: any) {
        return null;
      });
    return userData;
  }

  /**
   *  Sends a post request to server
   */
  async createUser(data: any): Promise<any> {
    let phone = data["phone"];
    if(!data["phone"])
      phone = "NULL";
    var postData = {
      username: data["username"],
      email: data["email"],
      first_name: data["firstName"],
      last_name: data["lastName"],
      password: data["password"],
      phone: phone,
    };
    let result = await API.post("/api/user/new", postData)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
      })
      .catch(function(error: any) {
        return {error: "Error connecting to the server"};
      });
    return result;
  }
}
