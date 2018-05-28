/*
INPUTS:
/ipi/research/xiaqu/MRI_FCD/FCD_T1/Patient_001/5_tissue_seg/Patient_001_r_brain_itp_restore.nii.gz
OUTPUTS:
/ipi/research/xiaqu/MRI_FCD/FCD_T1/Patient_001/6_Gradient_Map/Patient_001_r_brain_itp_restore_Gradient.nii.gz
Author:Xiaoxia Qu
Date:Oct.11.2013
*/

#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"

#include "itkRescaleIntensityImageFilter.h"
#include "itkGradientMagnitudeRecursiveGaussianImageFilter.h"


int main( int argc, char * argv[] )
{
// Verify the number of parameters in the command line
  if( argc < 4 )
    {
    std::cerr << "Usage: " << argv[0] << std::endl;
    std::cerr << " InputFile OutputFile sigma" << std::endl;
    return EXIT_FAILURE;
    }
  typedef float    PixelType;
  const unsigned int      Dimension = 3;
  typedef itk::Image< PixelType, Dimension >         ImageType;
  typedef itk::Image< unsigned char, Dimension >         ImageTypeOut;

// Prepare to read and write
  typedef itk::ImageFileReader< ImageType >  ReaderType; 
  typedef itk::ImageFileWriter< ImageTypeOut >  WriterType;
  
  ReaderType::Pointer reader = ReaderType::New();
  WriterType::Pointer writer = WriterType::New();

  reader->SetFileName( argv[1]);
  writer->SetFileName( argv[2] );
// Update
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
//---------Begin to process-------------------------------------------------------------
//--------------------------------------------------------------------------------------
  typedef itk::GradientMagnitudeRecursiveGaussianImageFilter<
                                               ImageType, ImageType >  FilterType;
  FilterType::Pointer filter = FilterType::New();
  filter->SetInput( reader->GetOutput() );
  const float sigma = atof( argv[3] );
  filter->SetSigma( sigma );
  filter->Update();

  typedef itk::RescaleIntensityImageFilter<
                   ImageType, ImageTypeOut > RescaleFilterType;

  RescaleFilterType::Pointer rescaler = RescaleFilterType::New();

  rescaler->SetOutputMinimum(   0 );
  rescaler->SetOutputMaximum( 255 );
  rescaler->SetInput( filter->GetOutput() );

std::cout << "Calculation is done." << std::endl;
//--------------------------------------------------------------------------------------
//---------Begin to write---------------------------------------------------------------
//--------------------------------------------------------------------------------------
    writer->SetInput( rescaler->GetOutput() );
    std::cout  << "Writing the image as " << std::endl << std::endl;
    std::cout  << argv[2] << std::endl << std::endl;
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

