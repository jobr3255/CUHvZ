
export default class User {
  protected id: number;
  protected username: string;
  private email: string;
  private firstName: string;
  private lastName: string;
  private clearance: number;
  private activated: boolean;
  private subscribed: boolean;
  private joinDate: string;

  constructor(data: any) {
    this.id = data["id"];
    this.username = data["username"];
    this.email = data["email"];
    this.firstName = data["first_name"];
    this.lastName = data["last_name"];
    this.clearance = data["clearance"];
    this.activated = data["activated"];
    this.subscribed = data["subscribed"];
    this.joinDate = data["join_date"];
  }

  /***************
      GETTERS
   ***************/

  getID(): number {
    return this.id;
  }

  getUsername(): string {
    return this.username;
  }

  getEmail(): string {
    return this.email;
  }

  getFirstName(): string {
    return this.firstName;
  }

  getLastName(): string {
    return this.lastName;
  }

  getClearance(): number {
    return this.clearance;
  }

  getActivated(): boolean {
    return this.activated;
  }

  getSubscribed(): boolean {
    return this.subscribed;
  }

  getJoinDate(): string {
    return this.joinDate;
  }

  /***************
      SETTERS
   ***************/

  setUsername(username: string) {
    this.username = username;
  }

  setEmail(email: string) {
    this.email = email;
  }

  setFirstName(name: string) {
    this.firstName = name;
  }

  setLastName(name: string) {
    this.lastName = name;
  }

  setClearance(clear: number) {
    this.clearance = clear;
  }

  setActivated(activated: boolean) {
    this.activated = activated;
  }

  setSubscribed(sub: boolean) {
    this.subscribed = sub;
  }

  setJoinDate(joinDate: string) {
    this.joinDate = joinDate;
  }
}
