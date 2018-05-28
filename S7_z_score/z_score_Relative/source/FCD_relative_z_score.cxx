//************************************************
//Author:Xiaoxia Qu
//Date:Oct.16.2013
//************************************************
#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkLabelStatisticsImageFilter.h"

#include "itkImageRegionIterator.h"
#include <itkImageRegionConstIterator.h>

#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;

//-----------------------------------------------------------------
int main(int argc, char *argv[])
{
    if( argc < 5 )
      {
      std::cerr << "Missing Parameters " << std::endl;
      std::cerr << "Usage[0]: " << argv[0];
      std::cerr << "[1]Patient_relabel  [2]Patient_z_score [3]Health_z_score " << std::endl;
      std::cerr << "[4]OutImage " << std::endl;
      return EXIT_FAILURE;
      }
  const unsigned int Dimension = 3;
  typedef float PixelType;
  typedef itk::Image<PixelType, Dimension >  ImageType;
  typedef itk::ImageFileReader< ImageType>   ReaderType;

  typedef itk::Image<unsigned char, Dimension >  LabelImageType;
  typedef itk::ImageFileReader<LabelImageType>   LabelReaderType;
  LabelReaderType::Pointer LabelImageReader = LabelReaderType::New();
  LabelImageReader->SetFileName( argv[1] );

  ReaderType::Pointer Reader2 = ReaderType::New();
  Reader2->SetFileName( argv[2] );
  ReaderType::Pointer Reader3 = ReaderType::New();
  Reader3->SetFileName( argv[3] );

  typedef itk::ImageFileWriter< ImageType >    WriterType;
  WriterType::Pointer writer = WriterType::New();
  writer->SetFileName( argv[4] );

//------------------------------------------------------------
  // Update
    try
      {      
      LabelImageReader->Update();
      Reader2->Update();
      Reader3->Update();
      }
    catch (itk::ExceptionObject &e)
      {
      std::cerr << "exception in file reader " << std::endl;
      std::cout << e << std::endl;
      return EXIT_FAILURE;
      }
 //----------------------------------------------------
  // Images prepare
  LabelImageType::Pointer LabelImage = LabelImageReader->GetOutput();
  ImageType::Pointer pImage = Reader2->GetOutput();
  ImageType::Pointer hImage = Reader3->GetOutput();
  //-----------------------
  ImageType::Pointer OutImage = ImageType::New();
  OutImage->SetRegions( pImage->GetLargestPossibleRegion());
  OutImage->SetSpacing( pImage->GetSpacing() );
  OutImage->SetOrigin( pImage->GetOrigin());
  OutImage->SetDirection(pImage->GetDirection());
  OutImage->Allocate();
  //-----------------------
  // Iterator prepare
  const ImageType::RegionType   region=pImage->GetBufferedRegion();

    typedef itk::ImageRegionConstIterator< LabelImageType > ConstIteratorType1;
    ConstIteratorType1    LabelIt (LabelImage, region);
    typedef itk::ImageRegionConstIterator< ImageType > ConstIteratorType2;
    ConstIteratorType2    pIt (pImage, region);
    ConstIteratorType2    hIt (hImage, region);

    typedef itk::ImageRegionIterator<ImageType>       IteratorType;
    IteratorType      OutIt(OutImage, region);
//----------------
// Statistics tool prepare
    typedef itk::LabelStatisticsImageFilter< ImageType, LabelImageType > LabelStatisticsImageFilterType;
    typedef LabelStatisticsImageFilterType::ValidLabelValuesContainerType ValidLabelValuesType;
    typedef LabelStatisticsImageFilterType::LabelPixelType                LabelPixelType;

    LabelStatisticsImageFilterType::Pointer plabelStatisticsImageFilter = LabelStatisticsImageFilterType::New();
    plabelStatisticsImageFilter->SetLabelInput( LabelImage);
    plabelStatisticsImageFilter->SetInput(pImage);
    plabelStatisticsImageFilter->Update();

    LabelStatisticsImageFilterType::Pointer hlabelStatisticsImageFilter = LabelStatisticsImageFilterType::New();
    hlabelStatisticsImageFilter->SetLabelInput( LabelImage);
    hlabelStatisticsImageFilter->SetInput(hImage);
    hlabelStatisticsImageFilter->Update();
//----------------------------------------

    PixelType pBackground=plabelStatisticsImageFilter->GetMinimum(1);
    PixelType hBackground=hlabelStatisticsImageFilter->GetMinimum(1);
    PixelType offset=(hBackground-pBackground);
//----------------------------------------
    OutIt.GoToBegin();
    LabelIt.GoToBegin();
    pIt.GoToBegin();
    hIt.GoToBegin();
    PixelType pMean;
    PixelType hMean;
    PixelType prob;

     while( !OutIt.IsAtEnd() )
       {

       if (LabelIt.Get()>1)
        {
           pMean=plabelStatisticsImageFilter->GetMean(LabelIt.Get());
           hMean=hlabelStatisticsImageFilter->GetMean(LabelIt.Get());

           prob=(pMean-hMean+offset);

           OutIt.Set(prob);
        }
        else   // Background
        {
           OutIt.Set(0);
        }

       ++LabelIt;
       ++pIt;
       ++hIt;
       ++OutIt;
       }
     //---------------------------------------------------------------------------
       writer->SetInput( OutImage);
         std::cout  << "Writing the image as " << std::endl;
         std::cout  << argv[4] << std::endl;
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


  return EXIT_SUCCESS;
}
 

