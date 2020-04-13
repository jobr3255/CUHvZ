import React from "react";
import API from "../util/API";
import Lockin from "../models/Lockin"
import LockinListing from "../components/events/LockinListing"
import FormattedText from "../components/layout/FormattedText"
import { Helmet } from "react-helmet";

/**
 * Controller for the LockinPage
 */
export default class LockinController {

  /**
   * Calls API and returns LockinListing object
   */
  async getLockinView(id: number): Promise<JSX.Element> {
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
