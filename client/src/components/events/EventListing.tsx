import React from "react";

export interface EventListingProps {
  id: number
}

export default abstract class EventListing< T > extends React.Component<T, any> {

}
