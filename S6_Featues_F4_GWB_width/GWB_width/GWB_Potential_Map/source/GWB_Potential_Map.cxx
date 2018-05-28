/*
  Author:Xiaoxia Qu
  Date:Oct.11.2013
*/
#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkNiftiImageIO.h"

#include "itkImageRegionIteratorWithIndex.h"
#include "itkNeighborhoodIterator.h"

//------------------------------------------------------------------

int main( int argc, char* argv[] )
{

// Verify the number of parameters in the command line
  if( argc < 3 )
    {
    std::cerr << "Usage: " << std::endl;
    std::cerr << argv[0] << std::endl;
    std::cerr << "[1]InImage  [2]OutImage [3](Optional)IterationTimes"<< std::endl;
    return EXIT_FAILURE;
    }

  typedef  double    PixelType;
  const unsigned int      Dimension = 3;
//---------------------------
  // define iteration times
    unsigned int h= 100;
    if (argc > 3)
    {
        h = atoi(argv[3]);
    }
  //  PixelType  GM=50;
  //  PixelType  WM=150;
  PixelType  GWB=100; // intensity in the region of interest (ROI)
//---------------------------

  typedef itk::Image< PixelType, Dimension >         ImageType;
  typedef itk::ImageFileReader< ImageType >          ReaderType;
  typedef itk::ImageFileWriter< ImageType >          WriterType;

  ReaderType::Pointer reader1 = ReaderType::New();
  reader1->SetFileName( argv[1]);

  ReaderType::Pointer reader2 = ReaderType::New();
  reader2->SetFileName( argv[1]);

  WriterType::Pointer writer = WriterType::New();
  writer->SetFileName( argv[2] );

 //------------pipeline-------------------

    typedef itk::NiftiImageIO       ImageIOType;
    ImageIOType::Pointer niftiIO =  ImageIOType::New();

    reader1->SetImageIO( niftiIO );
    reader2->SetImageIO( niftiIO );

    ImageType::Pointer     InputImage  = reader1->GetOutput();
    ImageType::Pointer     OutputImage = reader2->GetOutput();

    writer->SetInput( OutputImage);
    writer->SetImageIO( niftiIO );

//update
    try
      {
      reader1->Update();
      reader2->Update();
      }
    catch (itk::ExceptionObject &e)
      {
      std::cerr << "exception in file reader " << std::endl;
      std::cout << e << std::endl;
      return EXIT_FAILURE;
      }

//--------------------------------------------------------------------------------------
//---------process-----------------------------------------------------------------
//--------------------------------------------------------------------------------------

  ImageType::RegionType  region=reader1->GetOutput()->GetRequestedRegion();
// image iterator
typedef itk::ImageRegionIteratorWithIndex<ImageType> ImageRegionIteratorWithIndexType;
ImageRegionIteratorWithIndexType  in (InputImage, region);

// neighbourhood pointer--------------------------
   ImageType::SizeType radius;
// A radius of 1 in all axial directions gives a 3x3x3x3x... neighborhood.
for (unsigned int i_radius = 0; i_radius < Dimension; ++i_radius) radius[i_radius] = 1;
// Initializes the iterators on the input & output image regions
typedef itk::NeighborhoodIterator< ImageType > NeighborhoodIteratorType;
 NeighborhoodIteratorType out (radius, OutputImage, region);

  for (unsigned int i=1; i<h; i++) // 
  {
      for ( in.GoToBegin(), out.GoToBegin(); !in.IsAtEnd(); ++out, ++in)
      {
           if (in.Get()==GWB) // make sure this pixel is in the ROI
           {
               float Mean;
                      Mean=(out.GetPixel(4)+out.GetPixel(10)
                           +out.GetPixel(12)+out.GetPixel(14)
                           +out.GetPixel(16)+out.GetPixel(22))/6;
                   
                           out.SetCenterPixel (Mean);  // Laplace equation
           }          
      }
      std::cout << "Iteration: " << i << std::endl;
  }
//--------------------------------------------------------------------------------------
//---------Begin to write---------------------------------------------------------------
//--------------------------------------------------------------------------------------

std::cout  << "Writing the image as " << std::endl << std::endl;
std::cout  << argv[2] << std::endl << std::endl;
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
  return EXIT_SUCCESS;
}
