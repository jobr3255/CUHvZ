export default function Token(length: number): string {
  var token = "";
  while(token.length < length){
    token = token + Math.random().toString(36).substring(3, 15);
  }
  return token.substr(0, length);
}
