import React from 'react';
import './Tabulator.css';

/**
 * Tabulator properties
 */
interface TabulatorProps {
  id: string
}

/**
 * Tabulator states variables
 */
interface TabulatorStates {
  selectedTab: string | null
}

/**
 * Formats child Tab elements into tabs with content in each tab
 */
export default class Tabulator extends React.Component<TabulatorProps, TabulatorStates> {

  constructor(props: TabulatorProps) {
    super(props);
    this.state = {
      selectedTab: null
    };
    this.handleTabClick = this.handleTabClick.bind(this);
  }

  /**
   * Fires when component loads on page
   */
  componentDidMount() {
    var prevPage = sessionStorage.getItem('prevPage');
    var currentPage = sessionStorage.getItem('currentPage');
    if(currentPage === prevPage){
      var lastTabOpened = sessionStorage.getItem(`lastTabOpened-${this.props.id}`);
      this.setState({
        selectedTab: lastTabOpened
      });
    }
  }

  /**
   * Switches tab to clicked on tab
   */
  handleTabClick(e: any){
    var element = (e.target as HTMLElement);
    var elementID = element.getAttribute("id");
    this.setState({
      selectedTab: elementID
    });
    if(elementID){
      sessionStorage.setItem(`lastTabOpened-${this.props.id}`, elementID);
    }
  }

  render() {
    var tabButtons;
    var tabContents;
    if (this.props.children) {
      tabButtons = [];
      tabContents = [];
      var keyIndex = 1;
      React.Children.map(this.props.children, (tab: any) => {
        var active = "";
        var tabID = `${tab.props.id ? tab.props.id : tab.props.name}-tab-button`;
        var showContent = false;
        if(this.state.selectedTab){
          if(tabID === this.state.selectedTab){
            showContent = true;
            active = "active";
          }
        }else{
          if(tab.props.default){
            showContent = true;
            active = "active";
          }
        }
        tabButtons.push(
          <span className="tab" key={keyIndex++}>
            <button className={`tablink small-tab ${active}`} id={tabID} onClick={this.handleTabClick}>{tab.props.name}</button>
          </span>
        );
        if(showContent){
          tabContents = (
            <div key={keyIndex}>
              {tab.props.children}
            </div>
          );
        }
      });
    }
    return (
      <>
        <div style={{ margin: "auto", textAlign: "center" }}>
          {tabButtons}
        </div>
        <div id="tab-container">
          {tabContents}
        </div>
      </>
    );
  }
}

export * from "./Tab";
