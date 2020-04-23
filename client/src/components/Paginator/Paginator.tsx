import React from 'react';
import "./Paginator.css";

/**
 * Paginator properties
 */
interface PaginatorProps {
  perPage: number,
  id?: string,
  className?: string,
  reset?: boolean
}

/**
 * Paginator states variables
 */
interface PaginatorStates {
  currentPage: number,
  tableRows: HTMLTableRowElement[]
}

/**
 * Takes many rows in a table and "paginates" them
 */
export default class Paginator extends React.Component<PaginatorProps, PaginatorStates> {
  constructor(props: PaginatorProps) {
    super(props);
    this.state = {
      currentPage: 1,
      tableRows: []
    }
    this.handlePageClick = this.handlePageClick.bind(this);
    this.nextPage = this.nextPage.bind(this);
    this.previousPage = this.previousPage.bind(this);
  }

  /**
   * Fires when component loads on page
   */
  componentDidMount() {
    var child: any = React.Children.only(this.props.children);
    var id = "";
    if(child){
      id = child.props.id;
    }
    var tbody = document.getElementById(`${id}-tbody`);
    if (!tbody)
      return
    var trRows = tbody.getElementsByTagName("tr");
    var rows: HTMLTableRowElement[] = [];
    for (let i = 0; i < trRows.length; ++i) {
      rows.push(trRows[i]);
    }
    this.setState({
      currentPage: 1,
      tableRows: rows
    });
    this.navigateToPage(1, rows);
  }

  /**
   * Resets paginator to first page if the reset prop is different
   */
  componentWillReceiveProps(props: PaginatorProps) {
    const { reset } = this.props;
    console.log(`props.reset = ${props.reset} this.props.reset = ${this.props.reset}`);
    if (props.reset !== reset) {
      this.navigateToPage(1);
    }
  }

  /**
   * Switches to the next page
   */
  nextPage(){
    this.changePage(1);
  }

  /**
   * Switches to the previous page
   */
  previousPage(){
    this.changePage(-1);
  }

  /**
   * Switches the page by the specified number if able
   */
  changePage(num: number){
    var numPages = Math.ceil(this.state.tableRows.length / this.props.perPage);
    var currentPage = this.state.currentPage;
    currentPage += num;
    if(currentPage < 1)
      currentPage = 1;
    else if(currentPage > numPages)
      currentPage = numPages;
    this.navigateToPage(currentPage);
  }

  /**
   * Hanldes user selection of a page number
   */
  handlePageClick(e: any) {
    var element = (e.target as HTMLElement);
    var elementID = parseInt(element.innerText)
    this.navigateToPage(elementID);
  }

  /**
   * Hides / unhides the rows to represent a page
   */
  navigateToPage(pageNum: number, trRows?: any[]) {
    var rows = trRows ? trRows : this.state.tableRows;
    var perPage = this.props.perPage;
    for (let i = 0; i < rows.length; ++i) {
      let element = (rows[i] as HTMLElement);
      if(i >= (perPage * (pageNum - 1)) && i < (perPage * pageNum)){
        element.style.display = "";
      }else{
        element.style.display = "none";
      }
    }
    this.setState({
      currentPage: pageNum
    });
  }

  render() {
    var pages = [];
    var numPages = Math.ceil(this.state.tableRows.length / this.props.perPage);
    var keyIndex = 0;
    if (this.state.currentPage > 1)
      pages.push(<li key={keyIndex++} className="paginater"><span onClick={this.previousPage}>«</span></li>);
    for (let i = 1; i < numPages + 1; ++i) {
      var active = "";
      if(this.state.currentPage === i)
        active = "active"
      pages.push(<li key={keyIndex++} className="paginater"><span onClick={this.handlePageClick} className={`${active}`}>{i}</span></li>);
    }
    if (this.state.currentPage < numPages)
      pages.push(<li key={keyIndex++} className="paginater"><span onClick={this.nextPage}>»</span></li>);
    return (
      <>
        {this.props.children}
          <div className="paginator">
            <ul>
              {pages}
            </ul>
          </div>
      </>
    );
  }
}
