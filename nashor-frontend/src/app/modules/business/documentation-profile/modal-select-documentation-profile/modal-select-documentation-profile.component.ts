import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { DocumentationProfileService } from '../documentation-profile.service';
import { DocumentationProfile } from '../documentation-profile.types';
import { ModalSelectDocumentationProfileService } from './modal-select-documentation-profile.service';

@Component({
  selector: 'app-modal-select-documentation-profile',
  templateUrl: './modal-select-documentation-profile.component.html',
})
export class ModalSelectDocumentationProfileComponent implements OnInit {
  id_documentation_profile: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listDocumentationProfile: DocumentationProfile[] = [];
  selectDocumentationProfileForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _documentationProfileService: DocumentationProfileService,
    private _modalSelectDocumentationProfileService: ModalSelectDocumentationProfileService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of documentationProfile
     */
    this._documentationProfileService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_documentationProfiles: DocumentationProfile[]) => {
        this.listDocumentationProfile = _documentationProfiles;
      });
    /**
     * form
     */
    this.selectDocumentationProfileForm = this._formBuilder.group({
      id_documentation_profile: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectDocumentationProfileForm.patchValue({
      id_documentation_profile:
        this.selectDocumentationProfileForm.getRawValue()
          .id_documentation_profile,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_documentation_profile =
      this.selectDocumentationProfileForm.getRawValue().id_documentation_profile;
    this.patchForm();
  }
  /**
   * closeModalSelectDocumentationProfile
   */
  closeModalSelectDocumentationProfile(): void {
    this._modalSelectDocumentationProfileService.closeModalSelectDocumentationProfile();
  }
}
