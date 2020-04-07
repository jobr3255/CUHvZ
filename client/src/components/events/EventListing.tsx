import React from "react";

export interface EventListingProps {
  id: number,
  titleSize?: number
}
// ,
// titleSize?: number
export default abstract class EventListing< T > extends React.Component<T, any> {
  getTitle(titleLink: JSX.Element, titleSize: number){
    var title;
    switch (titleSize) {
      case 1:
        title = <h1 style={{margin: 0}}>{titleLink}</h1>
        break;
      case 2:
        title = <h2 style={{margin: 0}}>{titleLink}</h2>
        break;
      case 3:
        title = <h3 style={{margin: 0}}>{titleLink}</h3>
        break;
      default:
        title = <h4 style={{margin: 0}}>{titleLink}</h4>
        break;
    }
    return title;
  }
}
