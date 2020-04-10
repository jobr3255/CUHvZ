import React from 'react';
import './Tabulator.css';

export default class Tabulator extends React.Component<any, any> {

  constructor(props: any) {
    super(props);
    this.state = {
      selectedTab: null
    };
    this.handleTabClick = this.handleTabClick.bind(this);
  }

  componentDidMount() {
    var prevPage = sessionStorage.getItem('prevPage');
    var currentPage = sessionStorage.getItem('currentPage');
    if(currentPage === prevPage){
      var lastTabOpened = sessionStorage.getItem(`lastTabOpened-${this.props.id}`);
      console.log("open tab: "+lastTabOpened)
      this.setState({
        selectedTab: lastTabOpened
      });
    }
  }

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
        var activeStyle = {};
        var tabID = `${tab.props.name}-tab-button`;
        if(this.state.selectedTab){
          if(tabID === this.state.selectedTab){
            active = "active";
            activeStyle = {
              display: "block"
            };
          }
        }else{
          if(tab.props.default){
            active = "active";
            activeStyle = {
              display: "block"
            };
          }
        }
        tabButtons.push(
          <span className="tab" key={keyIndex++}>
            <button className={`tablink small-tab ${active}`} id={tabID} onClick={this.handleTabClick}>{tab.props.name}</button>
          </span>
        );
        tabContents.push(
          <div className="tabcontent" key={keyIndex} style={activeStyle}>
            {tab.props.children}
          </div>
        );
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
