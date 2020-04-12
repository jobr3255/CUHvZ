import React from 'react';
import "./Paginator.css";

interface PaginatorProps {
  perPage: number,
  id: string,
  className?: string,
  reset?: boolean
}

interface PaginatorPropsState {
  currentPage: number,
  tableRows: any[],
  ref: any
}

export default class Paginator extends React.Component<PaginatorProps, PaginatorPropsState> {
  constructor(props: PaginatorProps, ref: any) {
    super(props);
    this.state = {
      currentPage: 1,
      tableRows: [],
      ref: ref
    }
    this.handlePageClick = this.handlePageClick.bind(this);
    this.nextPage = this.nextPage.bind(this);
    this.previousPage = this.previousPage.bind(this);
  }

  componentDidMount() {
    var tbody = document.getElementById(`${this.props.id}-tbody`);
    if (!tbody)
      return
    var trRows = tbody.getElementsByTagName("tr");
    var rows: any[] = [];
    for (let i = 0; i < trRows.length; ++i) {
      rows.push(trRows[i]);
    }
    this.setState({
      currentPage: 1,
      tableRows: rows
    });
    this.navigateToPage(1, rows);
  }

  componentWillReceiveProps(props: PaginatorProps) {
    const { reset } = this.props;
    console.log(`props.reset = ${props.reset} this.props.reset = ${this.props.reset}`);
    if (props.reset !== reset) {
      this.navigateToPage(1);
    }
  }

  nextPage(){
    this.changePage(1);
  }

  previousPage(){
    this.changePage(-1);
  }

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

  handlePageClick(e: any) {
    var element = (e.target as HTMLElement);
    var elementID = parseInt(element.innerText)
    this.navigateToPage(elementID);
  }

  navigateToPage(pageNum: number, trRows?: any[]) {
    var rows = trRows ? trRows : this.state.tableRows;
    var perPage = this.props.perPage;
    // console.log(rows);
    for (let i = 0; i < rows.length; ++i) {
      let element = (rows[i] as HTMLElement);
      if(i >= (perPage * (pageNum - 1)) && i < (perPage * pageNum)){
        // console.log(element);
        element.hidden = false;
      }else{
        element.hidden = true;
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
      pages.push(<li key={keyIndex++} className="paginater"><span onClick={this.previousPage} className="page_link page-link">«</span></li>);
    for (let i = 1; i < numPages + 1; ++i) {
      var active = "";
      if(this.state.currentPage === i)
        active = "active"
      pages.push(<li key={keyIndex++} className="paginater"><span onClick={this.handlePageClick} className={`page_link page-link ${active}`}>{i}</span></li>);
    }
    if (this.state.currentPage < numPages)
      pages.push(<li key={keyIndex++} className="paginater"><span onClick={this.nextPage} className="page_link page-link">»</span></li>);
    return (
      <>
        {this.props.children}
        <div className="outer-div">
          <div className="inner-div">
            <ul className="pagination pagination-lg pager">
              {pages}
            </ul>
          </div>
        </div>
      </>
    );
  }
}
