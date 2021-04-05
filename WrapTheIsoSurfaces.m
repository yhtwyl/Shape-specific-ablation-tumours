function WrapedSurfaceVertices = WrapTheIsoSurfaces(WrapedSurfaceVertices,IsoSurfVerticesPostRotationPrev)
%myFun - Description
%
% Syntax: [] = WrapTheIsoSurfaces(WrapedSurfaceVertices,IsoSurfVerticesPostRotation_Prev)
%
% Long description
    radius = 30;
    Duplicate = IsoSurfVerticesPostRotationPrev;
    idx = inShape(alphaShape(WrapedSurfaceVertices,radius),Duplicate);
    Duplicate = Duplicate(~idx,:);
    idx = inShape(alphaShape(IsoSurfVerticesPostRotationPrev,radius),WrapedSurfaceVertices);
    WrapedSurfaceVertices = WrapedSurfaceVertices(~idx,:);
    WrapedSurfaceVertices = [WrapedSurfaceVertices;Duplicate];
end