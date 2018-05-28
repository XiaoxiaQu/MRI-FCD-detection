/*
INPUTS:
[1]Patient_001_r_brain_itp_mixeltype.nii.gz
GM_label=1, WM_label=2, CSF_label=3,GWB_label=5,Background_label=0
[2]Patient_001_r_brain_itp_restore.nii.gz
OUTPUTS:
[3]Patient_001_r_brain_itp_restore_RIM.nii.gz
Author:Xiaoxia Qu
Date:Oct.11.2013
*/

#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkNiftiImageIO.h"

#include "itkRescaleIntensityImageFilter.h"
#include "itkLabelStatisticsImageFilter.h"

#include "itkImageRegionIteratorWithIndex.h"
#include <stdlib.h>

//----------------------------------------------------------------------------------
int main( int argc, char * argv[] )
{
// Verify the number of parameters in the command line
  if( argc < 4 )
    {
    std::cerr << "Usage: " << argv[0] << std::endl;
    std::cerr << " [1]InputFile_label [2]InputFile_restore [3]OutputFile" << std::endl;
    return EXIT_FAILURE;
    }

// instantiating the image type to be read.
  typedef float    PixelType;
  const unsigned int      Dimension = 3;
  typedef itk::Image< PixelType, Dimension >         ImageType;
  typedef itk::Image< unsigned char, Dimension >     LabelImageType;

  PixelType  Threhold;
  PixelType  MeanOfGM;
  PixelType  MeanOfWM;

// Prepare to read and write
  typedef itk::ImageFileReader< ImageType >  ReaderType; 
  typedef itk::ImageFileWriter< ImageType >  WriterType;
  typedef itk::ImageFileReader< LabelImageType>  LabelReaderType;

  LabelReaderType::Pointer Label_reader = LabelReaderType::New();
  LabelReaderType::Pointer Label_reader2 = LabelReaderType::New();
  ReaderType::Pointer Restore_reader = ReaderType::New();
  WriterType::Pointer writer = WriterType::New();

  Label_reader->SetFileName( argv[1]);
  Label_reader2->SetFileName( argv[1]);
  Restore_reader->SetFileName( argv[2]);

  writer->SetFileName( argv[3] );
//--------------------------------------------------------------------------------------
//---------Begin to read---------------------------------------------------------------
//--------------------------------------------------------------------------------------
// NIFITI IO
  typedef itk::NiftiImageIO       ImageIOType;
  ImageIOType::Pointer niftiIO =  ImageIOType::New();

  Label_reader->SetImageIO( niftiIO );
  Label_reader2->SetImageIO( niftiIO );
  Restore_reader->SetImageIO( niftiIO );

// Update
    try
      {
  Label_reader->Update();
  Label_reader2->Update();
  Restore_reader->Update();

      }
    catch (itk::ExceptionObject &e)
      {
      std::cerr << "exception in file reader " << std::endl;
      std::cout << e << std::endl;
      return EXIT_FAILURE;
      }
std::cout << "All the data sets are loaded." << std::endl;
//--------------------------------------------------------------------------------------
//---------Begin to process-------------------------------------------------------------
//--------------------------------------------------------------------------------------

//************************************************
//Step 1: rescale image
//************************************************

typedef itk::RescaleIntensityImageFilter< ImageType, ImageType > RescaleType;
  RescaleType::Pointer rescaler = RescaleType::New();

  rescaler->SetInput( Restore_reader->GetOutput() );
  rescaler->SetOutputMinimum(0);
  rescaler->SetOutputMaximum(511);
  rescaler->Update();
//************************************************
//Step 2: Calculating the mean value of 100% GM region and 100% WM region
//************************************************

  typedef itk::LabelStatisticsImageFilter< ImageType, LabelImageType > LabelStatisticsImageFilterType;
  LabelStatisticsImageFilterType::Pointer labelStatisticsImageFilter = LabelStatisticsImageFilterType::New();
  labelStatisticsImageFilter->SetLabelInput( Label_reader->GetOutput());
  labelStatisticsImageFilter->SetInput(rescaler->GetOutput());
  labelStatisticsImageFilter->Update();

  typedef LabelStatisticsImageFilterType::ValidLabelValuesContainerType ValidLabelValuesType;
  typedef LabelStatisticsImageFilterType::LabelPixelType                LabelPixelType;

  LabelPixelType GMLavelValue=1;
  LabelPixelType WMLavelValue=2;
  MeanOfGM=static_cast<PixelType> (labelStatisticsImageFilter->GetMean( GMLavelValue )) ;
  MeanOfWM=static_cast<PixelType> (labelStatisticsImageFilter->GetMean( WMLavelValue )) ;
  Threhold=((MeanOfGM+MeanOfWM)/2);

//************************************************
//Step3: generate relative intensity map
//************************************************
    ImageType::Pointer     image = rescaler->GetOutput();
    LabelImageType::Pointer     LabelImage = Label_reader2->GetOutput();
    ImageType::Pointer     OutImage  =  ImageType::New();

    OutImage->SetLargestPossibleRegion(Restore_reader->GetOutput()->GetLargestPossibleRegion());
    OutImage->SetBufferedRegion(Restore_reader->GetOutput()->GetBufferedRegion());
    OutImage->SetRequestedRegion(Restore_reader->GetOutput()->GetRequestedRegion());
    OutImage->SetSpacing(Restore_reader->GetOutput()->GetSpacing());
    OutImage->SetOrigin( Restore_reader->GetOutput()->GetOrigin() );
    OutImage->SetDirection( Restore_reader->GetOutput()->GetDirection() );
    OutImage->Allocate();

// image iterator
typedef itk::ImageRegionIteratorWithIndex<ImageType> ImageRegionIteratorWithIndexType;
typedef itk::ImageRegionIteratorWithIndex<LabelImageType> LabelImageRegionIteratorWithIndexType;

ImageRegionIteratorWithIndexType  it (image, image->GetRequestedRegion());
LabelImageRegionIteratorWithIndexType  LabelIt (LabelImage, LabelImage->GetRequestedRegion());
ImageRegionIteratorWithIndexType  out (OutImage, OutImage->GetRequestedRegion());

 for ( it.GoToBegin(), out.GoToBegin(), LabelIt.GoToBegin() ; !it.IsAtEnd(); ++it, ++out, ++LabelIt)
 {
     if (it.Get()>1 & (LabelIt.Get()==1 | LabelIt.Get()==2 | LabelIt.Get()==5) )
     {
         out.Set(1-(abs(Threhold-it.Get())/Threhold)); // Cortex region
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

