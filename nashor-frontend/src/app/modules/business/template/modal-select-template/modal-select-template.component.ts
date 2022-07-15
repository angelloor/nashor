import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData } from 'app/core/app/app.type';
import { Subject, takeUntil } from 'rxjs';
import { TemplateService } from '../template.service';
import { Template } from '../template.types';
import { ModalSelectTemplateService } from './modal-select-template.service';

@Component({
  selector: 'app-modal-select-template',
  templateUrl: './modal-select-template.component.html',
})
export class ModalSelectTemplateComponent implements OnInit {
  id_template: string = '';
  id_company: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listTemplate: Template[] = [];
  selectTemplateForm!: FormGroup;
  private data!: AppInitialData;

  constructor(
    private _store: Store<{ global: AppInitialData }>,
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _templateService: TemplateService,
    private _modalSelectTemplateService: ModalSelectTemplateService
  ) {}

  ngOnInit(): void {
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * get the list of template
     */
    this._templateService
      .byCompanyQueryRead(this.id_company, '*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_templates: Template[]) => {
        this.listTemplate = _templates;
      });
    /**
     * form
     */
    this.selectTemplateForm = this._formBuilder.group({
      id_template: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectTemplateForm.patchValue({
      id_template: this.selectTemplateForm.getRawValue().id_template,
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
    this.id_template = this.selectTemplateForm.getRawValue().id_template;
    this.patchForm();
  }
  /**
   * closeModalSelectTemplate
   */
  closeModalSelectTemplate(): void {
    this._modalSelectTemplateService.closeModalSelectTemplate();
  }
}
