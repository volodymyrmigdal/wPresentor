( function _Presentor_s_()
{

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = function wRenderer( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Renderer';

//

function init( o )
{
  let self = this;

  _.workpiece.initFields( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( self.structure )
  self.form();
}

//

function form()
{
  let self = this;
  if( self._formed )
  return;
  if( _.strIs( self.structure ) )
  self.structure = _.stxt.Parser({ dataStr : self.structure })
  self.structure.form();
  self._formed = 1;
}

  // let src = 'HarvardX <<- https://harvardx.harvard.edu/';
  // let result = _.strSplit
  // ({
  //   src,
  //   // delimeter : [ '->>', '<<-', '!>>', '<<!', '>>', '<<', ' ' ],
  //   delimeter : [ ' ' ],
  //   preservingEmpty : 0,
  //   preservingDelimeters : 1,
  //   stripping : 0,
  // });
  //
  // console.log( src );
  // console.log( result );
  //
  // return; //
//
//   let structure =
// `
// = reputation
//
// == links
// ==- github
//
// == feedbacks
// ==- public
// ==- private
// ==- stats
// ==- success rate
// ==- top rated
//
// == tests
// ==- time it take
// ==- several attempts
// `;
//
// let structure =
// `
// = bionode-watermill <<- https://github.com/bionode/bionode-watermill
//
// ~~~ image:/amid_viewer/image/instrument.jpg
//
// is a workflow<<! engine for orchestrating complex and dynamic pipelines. The tool automatically resolves input and output filenames, while also maintaining a directed acyclic graph (DAG) of task dependencies. This enables the developer to isolate individual tasks and compose them with operators such as join, junction, and fork. Tasks can be child processes or JavaScript functions; of note is the ability to use Node streams which can be used to transform STDIN and STDOUT. Integration with Docker and clustering tools like qsub are some immediate<<! objectives of the <<- https://github.com/bionode/bionode-watermill project.
//
// aaa @thejmazz <<! <<- https://twitter.com/thejmazz bbb
//
// jmazz.me/slides/2016/10/24/bionode-watermill <<- http://jmazz.me/slides/2016/10/24/bionode-watermill
//
// = Agenda
//
// ~ list:ordered
//
// - Project history
// - What is a pipeline?
// - Example VCF Pipeline
// - What makes pipelines complex or dynamic?
// - Existing tools
// -- bash, makefile, python scripts
// -- snakemake <<- https://bitbucket.org/snakemake/snakemake/wiki/Home
// -- nextflow <<- https://www.nextflow.io/
// - bionode-watermill overall goals
// - Define a task
// - The task lifecycle
// - The DAG, input resolution, and operators
// - NGS Pipeline with watermill
// - Node streams
// - Node streams & child processes
// - Next Steps
//
// = Project History
//
// Google Summer of Code: May-August 2016 - >> Bionode workflow engine for streamed structure analysis <<- https://summerofcode.withgoogle.com/projects/=6585953724399616
// 4 weeks "community bonding", 12 weeks coding
// ended up spending first 4 weeks of code time figuring out what to do: my NGS Workflows post
// final 8 weeks to implement MVP of what was described in NGS Workflows post
//
// Mentors:
// Yannick Wurm, wurmlab. @yannick__
// Bruno Vieira, Phd student @ wurmlab, bionode founder. @bmpvieira
// Max Ogden, dat, open structure, Node. @denormalize
// Mathias Buus, dat, p2p, Node streams. @mafintosh
//
// = What is a pipeline?
//
// ~~ image:/amid_viewer/image/instrument.jpg
//
// == What is a pipeline?
//
// ~~~ halign:right image:/amid_viewer/image/instrument.jpg
//
// - Takes a source to a destination
// - source: raw structure generated by sequencing machines or otherwise - a file, set of files, or streaming output. (e.g. fastq)
// - destination: file(s) describing modeling/computational results (e.g. vcf) transformation from one format to another accomplished with "tools"
// - Tools <<! are usually written in C/C++, available as CLI binaries (maybe wrapped with Python/R)
// - Tools may:
// -- read one or many files, either >>explicitly or implicitly<<!
// -- write one or many files, either >>explicitly or implicitly<<!
// -- consume streaming STDIN and/or produce streaming STDOUT
// -- not give proper non-zero exit codes, change options across versions, log to STDERR, output empty files, etc...
// - Pipeline<<!: series of transformations applied with tools<<! to a source to produce a destination
// `

function pageRender( pageIndex )
{
  let self = this;

  // if( _.numberIs( pageIndex ) )
  // self.pageIndex = pageIndex;
  //
  // if( self.pageIndex === self.pageIndexCurrent )
  // return;
  //
  // self.pageIndexCurrent = self.pageIndex;

  // self.pageClear(); /* qqq : for Dmytro : investigate */

  _.assert( pageIndex === undefined || _.numberIs( pageIndex ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  let srcPage = self.structure.document.nodes[ pageIndex ];

  if( !srcPage )
  return self.errorReport( 'Page', pageIndex, 'not found' );

  const result = [];
  for( let k = 0 ; k < srcPage.nodes.length ; k++ )
  {
    let srcElement = srcPage.nodes[ k ];
    let dstElement = self._pageElmentExportHtml( srcElement, srcPage );
    result.push( dstElement );
    // self.genContentDom.nodes.push( dstElement );
  }
  return result;

  // for( let k = 0 ; k < srcPage.nodes.length ; k++ )
  // {
  //   let srcElement = srcPage.nodes[ k ];
  //   let dstElement = self._pageElmentExportHtml( srcElement, srcPage );
  //   self.genContentDom.nodes.push( dstElement );
  // }

  self.pageHeadDom.empty();
  self.pageHeadDom.nodes.push( self._pageElmentExportHtml( srcPage.head ) );
  self.pageHeadDom.attr( 'level', srcPage.level );

  self.pageNumberDom.text( ( pageIndex + 1 ) + ' / ' + self.structure.document.nodes.length );

  // let a = _.process.anchor();
  //
  // _.process.anchor
  // ({
  //   extend : { srcPage : self.pageIndexCurrent + 1 },
  //   del : { head : 1 },
  //   replacing : a.head ? 1 : 0,
  // });

}

//

function pageHeadNameChop( head )
{

  if( _.objectIs( head ) )
  head = head.text;

  _.assert( _.strIs( head ) );

  head = head.trim();
  head = head.toLowerCase();
  head = head.replace( /\s+/g, '_' );

  return head;
}

//

function pagesByHead( head )
{
  let self = this;

  head = self.pageHeadNameChop( head );

  let result = _.entityFilter( self.structure.document.nodes, function( e )
  {
    // console.log( self.pageHeadNameChop( e.head ) );
    if( self.pageHeadNameChop( e.head ) === head )
    return e;
  });

  return result;
}

//

function _pageElmentExportHtml( srcElement, srcPage )
{
  let self = this;
  let html;

  if( _.objectIs( srcElement ) )
  {
    if( srcElement.kind === 'List' )
    {
      html = self._pageListRender
      ({
        srcList : srcElement,
        srcPage : srcPage,
      });
    }
    else if( srcElement.kind === 'Link' )
    {
      html = _.html.A.make();
      if( srcElement.ref )
      html.attrs.href = srcElement.ref;
      html.text = srcElement.text;
    }
    else if( srcElement.kind === 'Line' || srcElement.kind === 'LineEmpty' )
    {
      html = _.html.P.make();
      html.nodes.push( self._pageElmentExportHtml( srcElement.nodes, srcPage ) );
    }
    else if( srcElement.kind === 'Sentiment' )
    {
      html = _.html.P.make();
      html.nodes.push( self._pageElmentExportHtml( srcElement.nodes, srcPage ) );
    }
    else if( srcElement.kind === 'Directive' )
    {

      if( srcElement.properties.image )
      {
        if( srcElement.properties.size === 'widest' )
        {
          html = _.html.Img.make();
          html.attrs.level = srcElement.level;
          html.attrs.src = srcElement.properties.image;
          html.attrs[ 'background-image' ] = 1;
        }
        else
        {
          html = _.html.Img.make();
          html.attrs.level = srcElement.level;
          html.attrs.src = srcElement.properties.image;
        }
      }

      if( srcElement.properties.halign )
      html.attrs.halign = srcElement.properties.halign;
      if( srcElement.properties.valign )
      html.attrs.valign = srcElement.properties.valign;

    }
    else if( srcElement.kind === 'Span' )
    {
      html = _.html.Span.make();
      if( srcElement.nodes )
      html.nodes.push( self._pageElmentExportHtml( srcElement.nodes, srcPage ) );
      if( srcElement.properties )
      html.attrs = srcElement.properties;
      html.text = srcElement.text;
    }

  }
  else if( _.arrayIs( srcElement ) )
  {
    let result = [];

    for( let i = 0 ; i < srcElement.length ; i++ )
    result.push( self._pageElmentExportHtml( srcElement[ i ], srcPage ) );

    return result;
  }
  else throw _.err( '_pageElmentExportHtml : unknown type : ' + _.entity.strType( srcElement ) ); /* */

  // return html.join( '' );
  return html;
}

// //
//
// function _pageElementMake( srcElement, srcPage )
// {
//   let self = this;
//   let html;
//
//   if( _.objectIs( srcElement ) ) /* */
//   {
//
//     if( srcElement.kind === 'List' )
//     html = self._pageListRender
//     ({
//       list : srcElement,
//       srcPage,
//     });
//     else if( srcElement.kind === 'Link' )
//     {
//       html = $( '<a>' );
//       html.attr( 'href', srcElement.ref );
//       let dstElement = self._pageElementMake( srcElement.nodes, srcPage );
//       html.nodes.push( dstElement );
//     }
//     else if( srcElement.kind === 'Line' )
//     {
//       html = $( '<p>' );
//       let dstElement = self._pageElementMake( srcElement.nodes, srcPage );
//       html.nodes.push( dstElement );
//     }
//     else if( srcElement.kind === 'Sentiment' )
//     {
//       html = $( '<span>' );
//       if( srcElement.sentiment === 'strong' )
//       html.addClass( 'strong' );
//       let dstElement = self._pageElementMake( srcElement.srcElement, srcPage );
//       html.nodes.push( dstElement );
//     }
//     else if( srcElement.kind === 'Directive' )
//     {
//       if( srcElement.map.image )
//       {
//
//         if( srcElement.map.size === 'widest' )
//         {
//           html = $( '<img>' );
//           html.attr( 'level', srcElement.level );
//           html.attr( 'src', srcElement.map.image );
//           html.attr( 'background-image', 1 );
//         }
//         else
//         {
//           html = $( '<img>' );
//           html.attr( 'level', srcElement.level );
//           html.attr( 'src', srcElement.map.image );
//         }
//
//       }
//
//       if( srcElement.map.height )
//       {
//         html.css( 'max-height', self.vminFor( srcElement.map.height ) );
//         html.css( 'width', 'auto' );
//       }
//       if( srcElement.map.width )
//       {
//         html.css( 'max-width', self.vminFor( srcElement.map.width ) );
//         html.css( 'height', 'auto' );
//       }
//
//       if( srcElement.map.halign )
//       html.attr( 'halign', srcElement.map.halign );
//       if( srcElement.map.valign )
//       html.attr( 'valign', srcElement.map.valign );
//
//     }
//     else if( srcElement.kind === 'Span' )
//     {
//
//       html = $( '<span>' );
//       html.text( srcElement.text );
//
//       if( srcElement.properties )
//       {
//         if( srcElement.properties.size )
//         {
//           let em = self.emFor( srcElement.properties.size );
//           html.css( 'line-height', em );
//           html.css( 'font-size', em );
//         }
//       }
//
//     }
//
//   }
//   else if( _.arrayIs( srcElement ) ) /* */
//   {
//     let result = [];
//
//     for( let i = 0 ; i < srcElement.length ; i++ )
//     {
//       result.push( self._pageElementMake( srcElement[ i ], srcPage ) );
//     }
//
//     return result;
//   }
//   else throw _.err( '_pageElementMake : unknown type : ' + _.entity.strType( srcElement ) ); /* */
//
//   return html;
// }

// //
//
// function _pageListRender( o )
// {
//   let self = this;
//
//   _.routine.options( _pageListRender, o );
//
//   /* */
//
//   let list = [ '<ul>' ];
//   let level = 1;
//
//   for( let k = 0 ; k < o.srcList.nodes.length ; k++ )
//   {
//     let srcElement = o.srcList.nodes[ k ];
//
//     levelSet( srcElement.level );
//
//     o.srcElement = srcElement;
//     o.key = k;
//     list.push( self._pageListElementMake( o ) );
//   }
//
//   list.push( '</ul>' );
//   return list;
//
//   /* */
//
//   function levelSet( newLevel )
//   {
//     if( level === newLevel )
//     return;
//
//     _.assert( 'not implemented' );
//
//     while( level < newLevel )
//     {
//       list = [ '<ul>' ];
//       lists[ lists.length-1 ].nodes.push( list );
//       lists.push( list );
//       level += 1;
//     }
//
//     while( level > newLevel )
//     {
//       lists.pop();
//       list = lists[ lists.length-1 ];
//       level -= 1;
//     }
//
//   }
//
// }
//
// _pageListRender.defaults =
// {
//   srcList : null,
//   srcPage : null,
// }

//

function _pageListRender( o )
{
  let self = this;

  _.routine.options( _pageListRender, o );
  o = _.mapExtend( null, o );

  /* */

  let dstList = _.html.Ul.make();
  let dstLists = [ dstList ];
  let level = 1;

  for( let k = 0 ; k < o.srcList.nodes.length ; k++ )
  {
    let srcItem = o.srcList.nodes[ k ];
    levelSet( srcItem.level );
    o.srcItem = srcItem;
    o.key = k;
    dstList.nodes.push( self._pageListElementMake( o ) );
  }

  return dstLists[ 0 ];

  /* */

  function levelSet( newLevel )
  {

    if( level === newLevel )
    return;

    while( level < newLevel )
    {
      dstList = _.html.Ul.make();
      dstLists[ dstLists.length-1 ].nodes.push( dstList );
      dstLists.push( dstList );
      level += 1;
    }

    while( level > newLevel )
    {
      dstLists.pop();
      dstList = dstLists[ dstLists.length-1 ];
      level -= 1;
    }
    // while( level < newLevel )
    // {
    //   let dstList = _.html.Ul.make();
    //   dstLists[ dstLists.length-1 ].nodes.push( dstList );
    //   dstLists.push( dstList );
    //   level += 1;
    // }
    //
    // while( level > newLevel )
    // {
    //   dstLists.pop();
    //   dstList = dstLists[ dstLists.length-1 ];
    //   level -= 1;
    // }

  }

}

_pageListRender.defaults =
{
  srcList : null,
  srcPage : null,
}

// //
//
// function _pageListRender( o )
// {
//   let self = this;
//
//   _.routine.options( _pageListRender, o );
//   o = _.mapExtend( null, o );
//
//   /* */
//
//   function levelSet( newLevel )
//   {
//
//     if( level === newLevel )
//     return;
//
//     while( level < newLevel )
//     {
//       list = $( '<ul>' );
//       lists[ lists.length-1 ].nodes.push( list );
//       lists.push( list );
//       level += 1;
//     }
//
//     while( level > newLevel )
//     {
//       lists.pop();
//       list = lists[ lists.length-1 ];
//       level -= 1;
//     }
//
//   }
//
//   /* */
//
//   let list = $( '<ul>' );
//   let lists = [ list ];
//   let level = 1;
//
//   for( let k = 0 ; k < o.srcList.nodes.length ; k++ )
//   {
//     let srcElement = o.srcList.nodes[ k ];
//
//     levelSet( srcElement.level );
//
//     o.srcElement = srcElement;
//     o.key = k;
//     list.nodes.push( self._pageListElementMake( o ) );
//   }
//
//   return lists[ 0 ];
// }
//
// _pageListRender.defaults =
// {
//   list : null,
//   srcPage : null,
// }

//

function _pageListElementMake( o )
{
  let self = this;

  _.routine.options( _pageListElementMake, o );

  let html = _.html.Li.make();
  html.nodes.push( self._pageElmentExportHtml( o.srcItem.nodes, o.srcPage ) );
  // html.push( dstElement );
  // html.push( '</li>' );

  return html;
}

_pageListElementMake.defaults =
{
  srcItem : null,
  key : null,
  srcList : null,
  srcPage : null,
};

// function _pageListElementMake( o )
// {
//   let self = this;
//
//   _.routine.options( _pageListElementMake, o );
//
//   let html = $( '<li>' );
//   let dstElement = self._pageElmentExportHtml( o.srcElement.srcElement, o.srcPage );
//
//   if( _.strIs( dstElement ) )
//   html.text( dstElement )
//   else
//   html.nodes.push( dstElement );
//
//   return html;
// }
//
// _pageListElementMake.defaults =
// {
//   srcElement : null,
//   key : null,
//   list : null,
//   srcPage : null,
// }

//

function errorReport( err )
{
  let self = this;
  throw err;
}

//

function vminFor( vmin )
{
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( vmin ) );
  _.assert( 0 <= vmin && vmin <= 10, 'vmin should be in range 0..10', vmin );
  return ( vmin * 100 ) + 'vmin';
}

//

function emFor( em )
{
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( em ) );
  _.assert( 0 <= em && em <= 1000, 'em should be in range 0..100', em );
  return ( em * 1 ) + 'em';
}

// --
// let
// --

let symbolForValues = Symbol.for( 'values' );

// --
// relationship
// --

let Composes =
{


  // dynamic : 0,
  // targetIdentity : '.wpresentor',
  // terminalCssClass : 'terminal',

  // rawData : null,
  structure : null,

  // pageIndex : 0,
  // pageIndexCurrent : -1,
  //
  // usingAnchorOnMake : 1,

}

let Aggregates =
{

}

let Associates =
{

  // targetDom : '.wpresentor',
  //
  // contentDomSelector : '{{targetDom}} > .content',
  // contentDom : null,
  //
  // menuDomSelector : '{{contentDomSelector}} > .presentor-menu',
  // menuDom : null,
  //
  // subContentDomSelector : '{{contentDomSelector}} > .sub-content',
  // subContentDom : null,
  //
  // genContentDomSelector : '{{contentDomSelector}} > .gen-content',
  // genContentDom : null,
  //
  // pageHeadDomSelector : '{{subContentDomSelector}} > .srcPage-head',
  // pageHeadDom : null,
  //
  // pageNumberDomSelector : '{{subContentDomSelector}} > .srcPage-number',
  // pageNumberDom : null,
  //
  // ellipsisDomSelector : '{{subContentDomSelector}} > .presentor-ellipsis',
  // ellipsisDom : null,

}

let Restricts =
{
  _formed : 0,
}

let Statics =
{
  // exec,
  // _exec,
}

// --
// proto
// --

let Proto =
{

  init,
  form,

  pageRender,

  pageHeadNameChop,
  pagesByHead,

  _pageElmentExportHtml,
  _pageListRender,
  _pageListElementMake,

  errorReport,
  vminFor,
  emFor,

  /* */

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

_.Copyable.mixin( Self );

// _.Instancing.mixin( Self );
// _.EventHandler.mixin( Self );

//

// _.ghi = _.ghi || Object.create( null );
// _global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;

_.presentor[ Self.shortName ] = Self;

// Self.exec();

})( );
