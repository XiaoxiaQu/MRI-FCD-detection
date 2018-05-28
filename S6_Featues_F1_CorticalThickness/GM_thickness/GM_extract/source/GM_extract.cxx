/*
INPUTS:
[1]Patient_001_r_brain_itp_pve_0.nii.gz
[2]Patient_001_r_brain_itp_pve_1.nii.gz
[3]Patient_001_r_brain_itp_pve_2.nii.gz
OUTPUTS:
[4]Patient_001_r_brain_itp_pve_GM.nii
Author:Xiaoxia Qu
Date:Oct.11.2013
*/

#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"

#include "itkImageRegionIteratorWithIndex.h"
#include "itkNiftiImageIO.h"

int main( int argc, char * argv[] )
{
// Verify the number of parameters in the command line
  if( argc < 5 )
    {
    std::cerr << "Usage: " << argv[0] << std::endl;
    std::cerr << " [1]pve_0  [2]pve_1 [3]pve_2 [4]OutputFile" << std::endl;
    return EXIT_FAILURE;
    }

// instantiating the image type to be read.
  typedef float    PixelType;
  const unsigned int      Dimension = 3;
  typedef itk::Image< PixelType, Dimension >         ImageType;

// Prepare to read and write
  typedef itk::ImageFileReader< ImageType >  ReaderType;
  typedef itk::ImageFileWriter< ImageType >  WriterType;

  ReaderType::Pointer CSF_reader = ReaderType::New();
  ReaderType::Pointer GM_reader = ReaderType::New();
  ReaderType::Pointer WM_reader = ReaderType::New();

  WriterType::Pointer writer = WriterType::New();

   CSF_reader->SetFileName( argv[1]);
   GM_reader->SetFileName( argv[2]);
   WM_reader->SetFileName( argv[3]);

   writer->SetFileName( argv[4] );
// Update
    try
      {
  CSF_reader->Update();
   GM_reader->Update();
   WM_reader->Update();

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
    ImageType::Pointer      CSF_Image = CSF_reader->GetOutput();
    ImageType::Pointer      GM_Image =  GM_reader->GetOutput();
    ImageType::Pointer      WM_Image =  WM_reader->GetOutput();

    ImageType::Pointer     OutputImage  =  ImageType::New();

    OutputImage->SetLargestPossibleRegion(GM_reader->GetOutput()->GetLargestPossibleRegion());
    OutputImage->SetBufferedRegion(GM_reader->GetOutput()->GetBufferedRegion());
    OutputImage->SetRequestedRegion(GM_reader->GetOutput()->GetRequestedRegion());
    OutputImage->SetSpacing(GM_reader->GetOutput()->GetSpacing());
    OutputImage->SetOrigin( GM_reader->GetOutput()->GetOrigin() );
    OutputImage->SetDirection( GM_reader->GetOutput()->GetDirection() );
    OutputImage->Allocate();
 //
   PixelType  CSF=50;
   PixelType  GM=100;
   PixelType  WM=150;
//
typedef itk::ImageRegionIteratorWithIndex<ImageType> ImageRegionIteratorWithIndexType;

ImageRegionIteratorWithIndexType  CSF_it (CSF_Image, CSF_Image->GetRequestedRegion());
ImageRegionIteratorWithIndexType   GM_it ( GM_Image,  GM_Image->GetRequestedRegion());
ImageRegionIteratorWithIndexType   WM_it ( WM_Image,  WM_Image->GetRequestedRegion());

ImageRegionIteratorWithIndexType  out (OutputImage, OutputImage->GetRequestedRegion());
CSF_it.GoToBegin();
GM_it.GoToBegin();
WM_it.GoToBegin();
out.GoToBegin();

while (!GM_it.IsAtEnd())
{
    if ( WM_it.Get()>0.9)
    {
        out.Set(WM);  // White Matter region
    }

    if (GM_it.Get()>0 )
    {
        out.Set(GM); // Cortex region, Gray Matter region
    }

    if (CSF_it.Get()>0)
    {
        out.Set(CSF);
    }
 ++CSF_it;
 ++GM_it;
 ++WM_it;
 ++out;
}

std::cout << "Calculation is done." << std::endl;
//--------------------------------------------------------------------------------------
//---------Begin to write---------------------------------------------------------------
//--------------------------------------------------------------------------------------
    writer->SetInput( OutputImage);
    std::cout  << "Writing the image as " << std::endl << std::endl;
    std::cout  << argv[4] << std::endl << std::endl;
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

