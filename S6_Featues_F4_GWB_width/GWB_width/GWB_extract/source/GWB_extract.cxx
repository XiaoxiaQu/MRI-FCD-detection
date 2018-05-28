/*
  Author:Xiaoxia Qu
  Date:Oct.11.2013
INPUTS:
[1]Patient_001_r_brain_itp_pve_1.nii.gz
[2]Patient_001_r_brain_itp_pve_2.nii.gz
OUTPUTS:
[3]Patient_001_r_brain_itp_pve_GWB.nii.gz
*/

#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"

#include "itkImageRegionIteratorWithIndex.h"
#include "itkNiftiImageIO.h"

int main( int argc, char * argv[] )
{
// Verify the number of parameters in the command line
  if( argc < 4 )
    {
    std::cerr << "Usage: " << argv[0] << std::endl;
    std::cerr << "[1]InFile_pve_1 [2]InFile_pve_2 [3]OutFile" << std::endl;
    return EXIT_FAILURE;
    }

// instantiating the image type to be read.
  typedef float    PixelType;
  const unsigned int      Dimension = 3;
  typedef itk::Image< PixelType, Dimension >         ImageType;

  //
    PixelType  GWB=100;
    PixelType  GM=50;
    PixelType  WM=150;


// Prepare to read and write
  typedef itk::ImageFileReader< ImageType >  ReaderType; 
  typedef itk::ImageFileWriter< ImageType >  WriterType;
  
  ReaderType::Pointer reader1 = ReaderType::New();
  ReaderType::Pointer reader2 = ReaderType::New();
  WriterType::Pointer writer = WriterType::New();

  reader1->SetFileName( argv[1]);
  reader2->SetFileName( argv[2]);
  writer->SetFileName( argv[3] );
//--------------------------------------------------------------------------------------
//---------Begin to read---------------------------------------------------------------
//--------------------------------------------------------------------------------------
// NIFITI IO
  typedef itk::NiftiImageIO       ImageIOType;
  ImageIOType::Pointer niftiIO =  ImageIOType::New();

  reader1->SetImageIO( niftiIO );
  reader2->SetImageIO( niftiIO );
// Update
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
//---------Begin to process-------------------------------------------------------------
//--------------------------------------------------------------------------------------
    ImageType::Pointer     InImage1  = reader1->GetOutput();
    ImageType::Pointer     InImage2  = reader2->GetOutput();
    ImageType::Pointer     OutImage  =  ImageType::New();

    OutImage->SetLargestPossibleRegion(reader1->GetOutput()->GetLargestPossibleRegion());
    OutImage->SetBufferedRegion(reader1->GetOutput()->GetBufferedRegion());
    OutImage->SetRequestedRegion(reader1->GetOutput()->GetRequestedRegion());
    OutImage->SetSpacing(reader1->GetOutput()->GetSpacing());
    OutImage->SetOrigin( reader1->GetOutput()->GetOrigin() );
    OutImage->SetDirection( reader1->GetOutput()->GetDirection() );
    OutImage->Allocate();

// image iterator

typedef itk::ImageRegionIteratorWithIndex<ImageType> ImageRegionIteratorWithIndexType;
ImageRegionIteratorWithIndexType  in1 (InImage1, InImage1->GetRequestedRegion());
ImageRegionIteratorWithIndexType  in2 (InImage2, InImage2->GetRequestedRegion());
ImageRegionIteratorWithIndexType  out (OutImage, OutImage->GetRequestedRegion());
 for ( in1.GoToBegin(), in2.GoToBegin(), out.GoToBegin(); !in1.IsAtEnd(); ++in1, ++in2, ++out)
 {

     if ((in1.Get()>0) & (in1.Get()<1) & (in2.Get()>0) & (in1.Get()<1))
     {
         out.Set(GWB); // GWB region

     }
     else if (in1.Get()==1)
     {
         out.Set(GM);  // Gray Matter region
     }
     else if (in2.Get()==1)
     {
         out.Set(WM);  // Gray Matter region
     }
     else
     {
         out.Set(0);
     }


 }

std::cout << "Calculation is done." << std::endl;
//--------------------------------------------------------------------------------------
//---------Begin to write---------------------------------------------------------------
//--------------------------------------------------------------------------------------
    writer->SetInput( OutImage);
    std::cout  << "Writing the image as " << std::endl << std::endl;
    std::cout  << argv[3] << std::endl << std::endl;
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
//---------Finish write-------------

  return EXIT_SUCCESS;
}

