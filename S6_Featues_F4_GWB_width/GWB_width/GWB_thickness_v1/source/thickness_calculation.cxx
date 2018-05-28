//------------------------------------------------------------------
// header files
#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkNiftiImageIO.h"

#include "itkImageRegionIteratorWithIndex.h"
#include "itkNeighborhoodIterator.h"

#include <math.h> 

//------------------------------------------------------------------

int main( int argc, char* argv[] )
{

// Verify the number of parameters in the command line
  if( argc < 3 )
    {
    std::cerr << "Usage: " << std::endl;
    std::cerr << argv[0] << " InputFilename  OutputFileName "
              << std::endl;
    return EXIT_FAILURE;
    }
// instantiating the image type to be read.
  typedef  float    PixelType;
  const unsigned int      Dimension = 3;

  typedef itk::Image< PixelType, Dimension >         ImageType;

//--------------------------------------------------------------------------------------
//---------Begin to read---------------------------------------------------------------
//--------------------------------------------------------------------------------------
  typedef itk::ImageFileReader< ImageType >        ReaderType;
  ReaderType::Pointer reader = ReaderType::New();
 reader->SetFileName( argv[1]);
//---------------------IO-----------------------------------------
// NIFITI IO
  typedef itk::NiftiImageIO       ImageIOType;
  ImageIOType::Pointer niftiIO =  ImageIOType::New();
//--------------------------------------------------------------
  reader->SetImageIO( niftiIO );
//--------------------------------------------------------------

//---------------------IO-----------------------------------------
    try
      {
      reader->Update();
      }
    catch (itk::ExceptionObject &e)
      {
      std::cerr << "exception in file reader " << std::endl;
      std::cout << e << std::endl;
      return EXIT_FAILURE;
      }
//--------------------------------------------------------------------------------------
//---------Finish read-----------------------------------------------------------------
//--------------------------------------------------------------------------------------


  ImageType::Pointer    inputImage = reader->GetOutput();
  ImageType::Pointer    outputImage= ImageType::New() ;
  

  outputImage->SetLargestPossibleRegion(reader->GetOutput()->GetLargestPossibleRegion());
  outputImage->SetBufferedRegion(reader->GetOutput()->GetBufferedRegion());
  outputImage->SetRequestedRegion(reader->GetOutput()->GetRequestedRegion());
  outputImage->SetSpacing(reader->GetOutput()->GetSpacing());
  outputImage->SetOrigin( reader->GetOutput()->GetOrigin() );
  outputImage->SetDirection( reader->GetOutput()->GetDirection() );
  outputImage->Allocate();
//---------------------------------------------------------------------------------
  ImageType::SpacingType spacing=reader->GetOutput()->GetSpacing();
  ImageType::RegionType  region=reader->GetOutput()->GetBufferedRegion();
 
//---------------------------------------------------------

  ImageType::IndexType  C_Index; 
  ImageType::IndexType  sonIndex;
  ImageType::IndexType  parIndex;
  ImageType::IndexType  sonIndex_tmp;
  ImageType::IndexType  parIndex_tmp;
//--------------------------------------------------------------------------
  ImageType::SizeType radius;
 // A radius of 1 in all axial directions gives a 3x3x3x3x... neighborhood.
for (unsigned int i = 0; i < Dimension; ++i) radius[i] = 1;
// Initializes the iterators on the input & output image regions
typedef itk::NeighborhoodIterator< ImageType > NeighborhoodIteratorType;
NeighborhoodIteratorType son_in (radius, inputImage, region);
NeighborhoodIteratorType par_in (radius, inputImage, region);
//----------------------------
typedef itk::ImageRegionIteratorWithIndex<ImageType> ImageRegionIteratorWithIndexType;
ImageRegionIteratorWithIndexType  out(outputImage, region);

//----------------------------------------------------------------------------


for ( out.GoToBegin(); !out.IsAtEnd(); ++out )
{   
       son_in.SetLocation(out.GetIndex());
       par_in.SetLocation(out.GetIndex());

 //----------------------------------------------------------------------------
       if ( (( (son_in.GetCenterPixel())<=50 ) | ((son_in.GetCenterPixel())>=150)) ) // background
       {
          out.Set(0);
          // std::cout << "One pixel is done. Index: " << out.GetIndex() << " value: " << out.Get() << std::endl;
       }
//----------------------------------------------------------------------------
       else if (region.IsInside(son_in.GetIndex()))
       {

           C_Index=out.GetIndex(); // perserve the current index


           //------------------find the son points-----------
           while ( (son_in.GetCenterPixel()>50) & (son_in.GetCenterPixel()<150) & (region.IsInside(son_in.GetIndex())))

        {

             NeighborhoodIteratorType::OffsetType son_nextMove;
             son_nextMove.Fill(0);
             PixelType max = son_in.GetCenterPixel();
             // PixelType max_tmp = son_in.GetCenterPixel();
             for ( unsigned int i = 0; i < son_in.Size(); ++i) //// find the neighbouring pixel with maximum value
             {
                 if ((son_in.GetPixel(i))>max)
                 {
                  max=son_in.GetPixel(i);                   // refresh the TEMP
                  son_nextMove = son_in.GetOffset(i);

                  }
             }
            sonIndex_tmp=son_in.GetIndex();
            son_in += son_nextMove;
            sonIndex=son_in.GetIndex();

            if (sonIndex_tmp==sonIndex)
            {
               break;
            }


        }
           //---------find the parent points-----------------------

             while ( (par_in.GetCenterPixel()>50) & (par_in.GetCenterPixel()<150) & (region.IsInside(par_in.GetIndex())))

          {

              NeighborhoodIteratorType::OffsetType par_nextMove;
              par_nextMove.Fill(0);
              PixelType min = par_in.GetCenterPixel();
              //  PixelType min_tmp = par_in.GetCenterPixel();
              for ( unsigned int j = 0; j < par_in.Size(); ++j) //// find the neighbouring pixel with maximum value
              {
                  if ((par_in.GetPixel(j))<min)
                  {
                   min =par_in.GetPixel(j);                   // refresh the TEMP
                   par_nextMove = par_in.GetOffset(j);

                   }
              }
             parIndex_tmp=par_in.GetIndex();
             par_in += par_nextMove;
             parIndex=par_in.GetIndex();

             if (parIndex_tmp==parIndex)
             {
                break;
             }


          }

              //-------------calculation of thickness --------------------------------------------------
              float thickness;
              float sonX=static_cast<PixelType>((C_Index[0]-sonIndex[0])*spacing[0]);
              float sonY=static_cast<PixelType>((C_Index[1]-sonIndex[1])*spacing[1]);
              float sonZ=static_cast<PixelType>((C_Index[2]-sonIndex[2])*spacing[2]);
              float parX=static_cast<PixelType>((C_Index[0]-parIndex[0])*spacing[0]);
              float parY=static_cast<PixelType>((C_Index[1]-parIndex[1])*spacing[1]);
              float parZ=static_cast<PixelType>((C_Index[2]-parIndex[2])*spacing[2]);

              thickness=sqrt(pow(sonX,2)+pow(sonY,2)+pow(sonZ,2))+sqrt(pow(parX,2)+pow(parY,2)+pow(parZ,2));
               
              out.Set(thickness);

               // std::cout << "One pixel is done. Index: " << out.GetIndex() << " value: " << out.Get() << std::endl;
            }
}


//--------------------------------------------------------------------------------------
//---------Begin to write---------------------------------------------------------------
//--------------------------------------------------------------------------------------
    typedef itk::ImageFileWriter< ImageType > WriterType;
    WriterType::Pointer writer = WriterType::New();
    writer->SetFileName( argv[2] );

    writer->SetInput( outputImage );

    std::cout  << "Writing the image as " << std::endl << std::endl;
    std::cout  << argv[2] << std::endl << std::endl;
//------------------IO-------------------------------------------
    writer->SetImageIO( niftiIO );
//------------------IO------------------------------------------

    try
    {
    writer->Update();
    }
  catch (itk::ExceptionObject & e)
    {
    std::cerr << "exception in file writer " << std::endl;
    std::cerr << e << std::endl;
    return EXIT_FAILURE;
    }
//--------------------------------------------------------------------------------------
//---------Finish write-----------------------------------------------------------------
//--------------------------------------------------------------------------------------

  return EXIT_SUCCESS;
}
