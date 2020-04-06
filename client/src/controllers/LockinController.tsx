import React from "react";
import API from "../util/API";
import Lockin from "../models/Lockin"
import LockinListing from "../components/events/LockinListing"
import FormattedText from "../components/layout/FormattedText"
import { Helmet } from "react-helmet";

export default class LockinController {

  async getLockinView(id: number) {
    let lockinData = await API.get(`/api/lockin/${id}`)
      .then(function(response: any) {
        if (response.status === 200) {
          return response.data;
        }
        return [];
      });
    var lockin = new Lockin(lockinData);
    return (
      <>
        <Helmet>
          <title>{lockin.getTitle()}</title>
        </Helmet>
        <LockinListing
          key={ lockin.getID() }
          id = { lockin.getID() }
          lockin = { lockin } />
        <FormattedText text={lockin.getDetails()} />
      </>);
  }
}
