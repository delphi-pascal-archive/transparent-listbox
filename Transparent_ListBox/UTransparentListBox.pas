unit UTransparentListBox;
  {composant écrit par Walter Irion et publié sur :
       http://www.swissdelphicenter.ch/torry/showcode.php?id=1982
   Utilisation par jean_jean pour delphifr

 *  TTransparentListBox is far from being a universal solution:
 *  it does not prevent Windows' scrolling mechanism from
 *  shifting the background along with scrolled listbox lines.
 *  Moreover, the scroll bar remains hidden until the keyboard
 *  is used to change the selection, and the scroll buttons
 *  become visible only when clicked.
 *
 *  To break it short: TTransparentListBox is only suitable
 *  for non-scrolling lists.
 *
 *  In fact it must be possible to write a listbox component
 *  that handles scrolling correctly. But my essays to intercept
 *  EM_LINESCROLL messages were fruitles, even though I tried
 *  subclassing via WndProc.
 *
 *  A solution for transparent TEdit and TMemo controls is
 *  introduced in issue 9/1996 of the c't magazine, again
 *  by Arne Sch?pers. But these are outright monsters with
 *  wrapper windows to receive notification messages as well
 *  as so-called pane windows that cover the actual control's
 *  client area and display its content.
 *
 *  They expect a crossed cheque amounting to DM 14,00
 *  to be included with your order, but I don't know about
 *  international orders.
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TTransparentListBox = class(TListBox)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
      override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    { Published declarations }
    property Style default lbOwnerDrawFixed;
    property Ctl3D default False;
    property BorderStyle default bsNone;
  end;

//procedure Register;

implementation

//procedure Register;
//begin
//  RegisterComponents('Samples', [TTransparentListBox]);
//end;

constructor TTransparentListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Ctl3D       := False;
  BorderStyle := bsNone;
  Style       := lbOwnerDrawFixed;  // changing it to lbStandard results
                                    // in loss of transparency
end;

procedure TTransparentListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
end;

procedure TTransparentListBox.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  Msg.Result := 1;           // Prevent background from getting erased
end;

procedure TTransparentListBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  tlbVisible: Boolean;
begin
  tlbVisible := (Parent <> nil) and IsWindowVisible(Handle);  // Check for visibility
  if tlbVisible then ShowWindow(Handle, SW_HIDE);             // Hide-Move-Show strategy...
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);          // ... to prevent background...
  if tlbVisible then ShowWindow(Handle, SW_SHOW);             // ... from getting copied
end;

procedure TTransparentListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  FoundStyle: TBrushStyle;
  R: TRect;
begin
  FoundStyle := Canvas.Brush.Style;       // Remember the brush style

  R := Rect;                                     // Adapt coordinates of drawing rect...
  MapWindowPoints(Handle, Parent.Handle, R, 2);  // ... to parent's coordinate system
  InvalidateRect(Parent.Handle, @R, True);   // Tell parent to redraw the item Position
  Parent.Update;                             // Trigger instant redraw (required)

  if not (odSelected in State) then
  begin  // If an unselected line is being handled
    Canvas.Brush.Style := bsClear;  //   use a transparent background
  end
  else
  begin                          // otherwise, if the line needs to be highlighted,
    Canvas.Brush.Style := bsSolid;  //   some colour to the brush is essential
  end;

  inherited DrawItem(Index, Rect, State); // Do the regular drawing and give component users...
  // ... a chance to provide an OnDrawItem handler

  Canvas.Brush.Style := FoundStyle;  // Boy-scout rule No. 1: leave site as you found it
end;


end.
