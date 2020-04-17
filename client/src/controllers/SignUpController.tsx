import API from "../util/API";

/**
 * Controller for the SignUpPage
 */
export default class SignUpController {

  /**
   *  Gets usernames and emails from the database
   */
  async getUsersList(): Promise<any[]> {
    let userData = await API.get("/api/users")
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    return userData;
  }
}
